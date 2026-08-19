import Foundation
import StoreKit

/*
 AppleIAPService 使用说明
 ========================

 这是 StoreKit 1 内购封装，只做三件事：拉商品、走支付队列、取出收据。
 发货（把收据交给服务端验单、给用户加钻）必须由业务通过 receiptVerifier 注入，本类不耦合具体接口。

 接入顺序
 --------
 1. App 启动尽早设置 receiptVerifier，再调用 start()。
    未完成交易会在启动时再次投递，晚注册观察者会漏单。
 2. 进入购买页后 fetchProducts(productIds:)，用返回的 productIdentifier 匹配业务商品。
    禁止按下标对齐服务端列表和苹果商品。
 3. 用户点购买：purchase(product:) 或 purchase(productId:)。
    按 ID 购买前必须已经 fetch 成功，否则 productNotFound。
 4. 支付成功后本类取出收据，回调 receiptVerifier。
    业务把 receiptBase64 + 自己的 projectId 发给服务端（如 accept_client_tokens）。
    服务端确认到账后 completion(.success(()))，本类才会 finishTransaction。
    失败则 completion(.failure(...))，本类不 finish，下次启动或 retryUnfinishedTransactions() 会重试。

 receiptVerifier 必须遵守
 ------------------------
 - 任意线程都可能进来，但必须且只能回调一次。
 - 成功才返回 success；网络错误、服务端拒绝都返回 failure。
 - 不要在闭包里自行 finishTransaction。
 - Ask to Buy 审批通过后，不会再次触发当次 purchase 的 completion，只走本闭包。
   因此闭包成功后业务必须自己刷新余额（发通知 / 重新拉钱包）。

 购买结果
 --------
 - finished：苹果扣款完成，且服务端验单成功，交易已 finish。
 - deferred：家庭共享「询问购买」，等待监护人审批。此时不要当成功发货。
   审批通过后苹果会再回调 purchased，发货只走 receiptVerifier。
 - cancelled：用户关掉支付弹窗。
 - verificationFailed：钱可能已扣，但服务端还没确认。交易仍留在队列，可稍后重试，不要再发起一笔新支付。
 - purchaseInProgress：已有一笔购买在飞，先等它结束。
 - 若队列里已有同一商品未 finish 的交易，purchase 不会再向苹果下新单，只会补验单。

 其他
 ----
 - fetchProducts 不受 canMakePayments 限制，关闭内购的设备仍可展示价格。
 - restorePurchases 的 completion 只表示苹果投递结束，发货仍看 receiptVerifier。
   消耗型商品（如星钻）通常恢复不到，漏单靠未完成交易重试，不要依赖 restore。
 - accountHint 必须传混淆后的账号标识，禁止明文 userId / 邮箱。
 - App Store 推广内购：未设置 promotedPurchaseHandler 时会暂存。
   登录完成后再 commitPromotedPurchaseIfNeeded()。
 - 购买进行中不要调用 stop()。
 - 仍使用整张 App Receipt，是为了兼容现有 accept_client_tokens，不是 StoreKit 2。

 接入示例（星钻）
 ----------------
 AppleIAPService.shared.receiptVerifier = { productId, transaction, receipt, completion in
     VFCCClientTokensRequest.loadData(projectId: 当前档位projectId, clientTokens: receipt)
         .subscribe(onNext: { response in
             completion(response.code == 0 ? .success(()) : .failure(NSError(domain: "vfcc", code: response.code ?? -1)))
         }, onError: { error in
             completion(.failure(error))
         })
 }
 AppleIAPService.shared.start()

 AppleIAPService.shared.fetchProducts(productIds: ["01", "02", "03"]) { result in
     // 用 result.products 的 productIdentifier 去对服务端商品
 }

 AppleIAPService.shared.purchase(productId: "01") { result in
     switch result {
     case .success(.finished):    // 刷新星钻余额
         break
     case .success(.deferred):    // 提示等待监护人审批
         break
     case .failure(.cancelled):   // 用户取消，无需 toast 成失败
         break
     case .failure:
         break
     }
 }
 */

// MARK: - Error

enum AppleIAPError: Error {
    case paymentsNotAllowed
    case emptyProductIdentifiers
    case requestFailed(Error)
    case emptyProducts
    case invalidProducts([String])
    case productNotFound(String)
    case invalidQuantity
    case purchaseInProgress
    case missingReceipt
    case cancelled
    case requestReplaced
    case storeFailed(Error)
    case verificationFailed(Error)
    case verifierNotSet
    case restoreFailed(Error)
    case receiptRefreshFailed(Error)
    case unknown
}

extension AppleIAPError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .paymentsNotAllowed:
            return "当前设备不允许应用内购买"
        case .emptyProductIdentifiers:
            return "商品 ID 不能为空"
        case .requestFailed(let error):
            return error.localizedDescription
        case .emptyProducts:
            return "未获取到可用商品"
        case .invalidProducts(let ids):
            return "无效商品 ID: \(ids.joined(separator: ", "))"
        case .productNotFound(let productId):
            return "未找到商品 \(productId)"
        case .invalidQuantity:
            return "购买数量必须大于 0"
        case .purchaseInProgress:
            return "已有购买正在进行"
        case .missingReceipt:
            return "未获取到购买凭证"
        case .cancelled:
            return "已取消购买"
        case .requestReplaced:
            return "商品请求已被新的请求替换"
        case .storeFailed(let error):
            return error.localizedDescription
        case .verificationFailed(let error):
            return error.localizedDescription
        case .verifierNotSet:
            return "未设置凭证校验"
        case .restoreFailed(let error):
            return error.localizedDescription
        case .receiptRefreshFailed(let error):
            return error.localizedDescription
        case .unknown:
            return "未知的购买错误"
        }
    }
}

// MARK: - Public result

/// 一次商品查询的结果。部分 ID 无效时，仍可能返回其余有效商品。
struct AppleIAPProductsResult {
    let products: [SKProduct]
    let invalidProductIdentifiers: [String]
}

/// 购买成功路径。Ask to Buy 审批中走 `deferred`，此时尚未 finish，也尚未发货。
enum AppleIAPPurchaseResult {
    case finished(SKPaymentTransaction)
    case deferred(SKPaymentTransaction)
}

/// 服务端验单。必须在任意线程、且只回调一次。
/// - 成功：本类才会 `finishTransaction`，否则苹果会在下次启动再次投递该笔交易。
/// - 失败：不 finish，便于漏单重试；切勿在失败时自行 finish。
typealias AppleIAPVerifyHandler = (
    _ productId: String,
    _ transaction: SKPaymentTransaction,
    _ receiptBase64: String,
    _ completion: @escaping (Result<Void, Error>) -> Void
) -> Void

// MARK: - Service

/// StoreKit 1 内购封装。只负责商品查询、支付队列和收据取出；发货校验由 `receiptVerifier` 注入。
///
/// 使用要点：
/// 1. 进程启动尽早调用 `start()`，并先设置 `receiptVerifier`，避免漏掉未完成交易。
/// 2. 按 `productIdentifier` 匹配商品，不要用列表下标。
/// 3. 消耗型商品同样必须验单成功后再 finish，否则会丢单。
/// 4. Ask to Buy 的 `deferred` 只表示等待审批；审批通过后的发货只走 `receiptVerifier`，不会再次触发本次 purchase completion。
final class AppleIAPService: NSObject {
    static let shared = AppleIAPService()

    /// 未设置时，已支付交易不会被 finish，以免未发货就关闭订单。
    var receiptVerifier: AppleIAPVerifyHandler? {
        didSet {
            guard receiptVerifier != nil else { return }
            retryUnfinishedTransactions()
        }
    }

    /// App Store 推广内购。返回 `true` 立即进入支付；返回 `false` 会暂存，稍后调用 `commitPromotedPurchaseIfNeeded()`。
    /// 未设置时默认暂存，避免未登录就拉起支付。
    var promotedPurchaseHandler: ((SKPayment, SKProduct) -> Bool)?

    private let syncQueue = DispatchQueue(label: "apple.iap.service.sync")
    private var isObserving = false
    private var productsById: [String: SKProduct] = [:]
    private var productsRequest: SKProductsRequest?
    private var receiptRefreshRequest: SKReceiptRefreshRequest?
    private var fetchCompletion: ((Result<AppleIAPProductsResult, AppleIAPError>) -> Void)?
    private var purchaseCompletion: ((Result<AppleIAPPurchaseResult, AppleIAPError>) -> Void)?
    private var restoreCompletion: ((Result<Void, AppleIAPError>) -> Void)?
    private var purchasingProductId: String?
    private var verifyingKeys = Set<String>()
    private var transactionsWaitingReceipt: [SKPaymentTransaction] = []
    private var pendingPromotedPayment: SKPayment?
    private var isRefreshingReceipt = false

    var canMakePayments: Bool {
        SKPaymentQueue.canMakePayments()
    }

    var products: [SKProduct] {
        syncQueue.sync { Array(productsById.values) }
    }

    var productsSortedByPrice: [SKProduct] {
        syncQueue.sync { self.sortedProductsUnsafe() }
    }

    private override init() {
        super.init()
    }

    deinit {
        stop()
    }

    /// 向支付队列注册观察者。可重复调用，内部只会 add 一次。
    func start() {
        syncQueue.async { [weak self] in
            self?.startUnsafe()
        }
    }

    /// 移除观察者。购买进行中不要调用，否则会漏掉后续状态。
    func stop() {
        syncQueue.async { [weak self] in
            guard let self = self, self.isObserving else { return }
            SKPaymentQueue.default().remove(self)
            self.isObserving = false
        }
    }

    func product(id: String) -> SKProduct? {
        syncQueue.sync { productsById[id] }
    }

    /// 拉取 App Store 商品。不受 `canMakePayments` 限制，关闭购买的设备仍应能展示价格。
    func fetchProducts(
        productIds: Set<String>,
        completion: @escaping (Result<AppleIAPProductsResult, AppleIAPError>) -> Void
    ) {
        syncQueue.async { [weak self] in
            self?.fetchProductsUnsafe(productIds: productIds, completion: completion)
        }
    }

    /// 按商品 ID 购买。必须先成功 `fetchProducts`，本地没有该商品会返回 `productNotFound`。
    func purchase(
        productId: String,
        accountHint: String? = nil,
        quantity: Int = 1,
        completion: @escaping (Result<AppleIAPPurchaseResult, AppleIAPError>) -> Void
    ) {
        syncQueue.async { [weak self] in
            self?.purchaseUnsafe(
                productId: productId,
                accountHint: accountHint,
                quantity: quantity,
                completion: completion
            )
        }
    }

    /// `accountHint` 须为混淆后的账号标识，用于欺诈检测，禁止传明文 userId / 邮箱。
    func purchase(
        product: SKProduct,
        accountHint: String? = nil,
        quantity: Int = 1,
        completion: @escaping (Result<AppleIAPPurchaseResult, AppleIAPError>) -> Void
    ) {
        syncQueue.async { [weak self] in
            self?.purchaseUnsafe(product: product, accountHint: accountHint, quantity: quantity, completion: completion)
        }
    }

    /// 回调只表示苹果已投递完恢复交易，发货结果仍以 `receiptVerifier` 为准。
    func restorePurchases(completion: @escaping (Result<Void, AppleIAPError>) -> Void) {
        syncQueue.async { [weak self] in
            guard let self = self else { return }
            self.startUnsafe()
            if let previous = self.restoreCompletion {
                self.restoreCompletion = nil
                self.notify(previous, .failure(.requestReplaced))
            }
            self.restoreCompletion = completion
            SKPaymentQueue.default().restoreCompletedTransactions()
        }
    }

    /// 重放队列中已支付但尚未 finish 的交易。启动后、验单闭包就绪时都应调用。
    func retryUnfinishedTransactions() {
        syncQueue.async { [weak self] in
            self?.retryUnfinishedTransactionsUnsafe()
        }
    }

    /// 继续此前被暂存的 App Store 推广购买。
    func commitPromotedPurchaseIfNeeded() {
        syncQueue.async { [weak self] in
            guard let self = self, let payment = self.pendingPromotedPayment else { return }
            self.pendingPromotedPayment = nil
            self.startUnsafe()
            SKPaymentQueue.default().add(payment)
        }
    }

    // MARK: - Private (syncQueue)

    private func startUnsafe() {
        dispatchPrecondition(condition: .onQueue(syncQueue))
        guard !isObserving else { return }
        SKPaymentQueue.default().add(self)
        isObserving = true
    }

    private func sortedProductsUnsafe() -> [SKProduct] {
        dispatchPrecondition(condition: .onQueue(syncQueue))
        return Array(productsById.values).sorted { $0.price.doubleValue < $1.price.doubleValue }
    }

    private func fetchProductsUnsafe(
        productIds: Set<String>,
        completion: @escaping (Result<AppleIAPProductsResult, AppleIAPError>) -> Void
    ) {
        dispatchPrecondition(condition: .onQueue(syncQueue))
        guard !productIds.isEmpty else {
            notify(completion, .failure(.emptyProductIdentifiers))
            return
        }
        if let previous = fetchCompletion {
            fetchCompletion = nil
            notify(previous, .failure(.requestReplaced))
        }
        fetchCompletion = completion
        productsRequest?.cancel()
        let request = SKProductsRequest(productIdentifiers: productIds)
        request.delegate = self
        productsRequest = request
        request.start()
    }

    private func purchaseUnsafe(
        productId: String,
        accountHint: String?,
        quantity: Int,
        completion: @escaping (Result<AppleIAPPurchaseResult, AppleIAPError>) -> Void
    ) {
        dispatchPrecondition(condition: .onQueue(syncQueue))
        guard let product = productsById[productId] else {
            notify(completion, .failure(.productNotFound(productId)))
            return
        }
        purchaseUnsafe(product: product, accountHint: accountHint, quantity: quantity, completion: completion)
    }

    private func purchaseUnsafe(
        product: SKProduct,
        accountHint: String?,
        quantity: Int,
        completion: @escaping (Result<AppleIAPPurchaseResult, AppleIAPError>) -> Void
    ) {
        dispatchPrecondition(condition: .onQueue(syncQueue))
        startUnsafe()
        guard SKPaymentQueue.canMakePayments() else {
            notify(completion, .failure(.paymentsNotAllowed))
            return
        }
        guard quantity >= 1 else {
            notify(completion, .failure(.invalidQuantity))
            return
        }
        guard purchaseCompletion == nil else {
            notify(completion, .failure(.purchaseInProgress))
            return
        }
        purchaseCompletion = completion
        purchasingProductId = product.productIdentifier
        if let pending = pendingPurchasedTransactionUnsafe(for: product.productIdentifier) {
            // 队列里已有同一商品的未 finish 交易，禁止再发起一笔新支付，只做验单补发货。
            handlePurchasedUnsafe(pending)
            return
        }
        let payment = SKMutablePayment(product: product)
        payment.quantity = quantity
        // Apple 要求这里放混淆后的用户标识，不要放明文邮箱或 userId。
        if let accountHint = accountHint, !accountHint.isEmpty {
            payment.applicationUsername = accountHint
        }
        SKPaymentQueue.default().add(payment)
    }

    private func retryUnfinishedTransactionsUnsafe() {
        dispatchPrecondition(condition: .onQueue(syncQueue))
        startUnsafe()
        guard receiptVerifier != nil else { return }
        for transaction in SKPaymentQueue.default().transactions {
            switch transaction.transactionState {
            case .purchased, .restored:
                handlePurchasedUnsafe(transaction)
            default:
                break
            }
        }
    }

    private func pendingPurchasedTransactionUnsafe(for productId: String) -> SKPaymentTransaction? {
        dispatchPrecondition(condition: .onQueue(syncQueue))
        return SKPaymentQueue.default().transactions.first {
            $0.payment.productIdentifier == productId &&
            ($0.transactionState == .purchased || $0.transactionState == .restored)
        }
    }

    private func isCurrentPurchase(_ transaction: SKPaymentTransaction) -> Bool {
        dispatchPrecondition(condition: .onQueue(syncQueue))
        return transaction.payment.productIdentifier == purchasingProductId
    }

    private func transactionKey(_ transaction: SKPaymentTransaction) -> String {
        if let identifier = transaction.transactionIdentifier, !identifier.isEmpty {
            return identifier
        }
        return transaction.payment.productIdentifier
    }

    private func completePurchaseUnsafe(_ result: Result<AppleIAPPurchaseResult, AppleIAPError>) {
        dispatchPrecondition(condition: .onQueue(syncQueue))
        let completion = purchaseCompletion
        purchaseCompletion = nil
        purchasingProductId = nil
        guard let completion = completion else { return }
        notify(completion, result)
    }

    private func completeFetchUnsafe(_ result: Result<AppleIAPProductsResult, AppleIAPError>) {
        dispatchPrecondition(condition: .onQueue(syncQueue))
        let completion = fetchCompletion
        fetchCompletion = nil
        productsRequest = nil
        guard let completion = completion else { return }
        notify(completion, result)
    }

    private func completeRestoreUnsafe(_ result: Result<Void, AppleIAPError>) {
        dispatchPrecondition(condition: .onQueue(syncQueue))
        let completion = restoreCompletion
        restoreCompletion = nil
        guard let completion = completion else { return }
        notify(completion, result)
    }

    private func notify<T>(_ completion: @escaping (Result<T, AppleIAPError>) -> Void, _ result: Result<T, AppleIAPError>) {
        DispatchQueue.main.async {
            completion(result)
        }
    }

    private func loadReceiptBase64() -> String? {
        guard let receiptURL = Bundle.main.appStoreReceiptURL,
              FileManager.default.fileExists(atPath: receiptURL.path),
              let receiptData = try? Data(contentsOf: receiptURL),
              !receiptData.isEmpty else {
            return nil
        }
        // 与现有后端 accept_client_tokens 保持一致；部分服务端按 64 列换行解码。
        return receiptData.base64EncodedString(options: .endLineWithLineFeed)
    }

    private func handlePurchasedUnsafe(_ transaction: SKPaymentTransaction) {
        dispatchPrecondition(condition: .onQueue(syncQueue))
        let key = transactionKey(transaction)
        guard !verifyingKeys.contains(key) else { return }
        verifyingKeys.insert(key)

        guard let receipt = loadReceiptBase64() else {
            verifyingKeys.remove(key)
            if !transactionsWaitingReceipt.contains(where: { self.transactionKey($0) == key }) {
                transactionsWaitingReceipt.append(transaction)
            }
            refreshReceiptUnsafe()
            return
        }
        startVerifyUnsafe(transaction, receipt: receipt)
    }

    private func startVerifyUnsafe(_ transaction: SKPaymentTransaction, receipt: String) {
        dispatchPrecondition(condition: .onQueue(syncQueue))
        let key = transactionKey(transaction)
        guard let verifier = receiptVerifier else {
            verifyingKeys.remove(key)
            if isCurrentPurchase(transaction) {
                completePurchaseUnsafe(.failure(.verifierNotSet))
            }
            return
        }
        let productId = transaction.payment.productIdentifier
        DispatchQueue.main.async { [weak self] in
            verifier(productId, transaction, receipt) { result in
                guard let self = self else { return }
                self.syncQueue.async {
                    self.verifyingKeys.remove(key)
                    switch result {
                    case .success:
                        SKPaymentQueue.default().finishTransaction(transaction)
                        if self.isCurrentPurchase(transaction) {
                            self.completePurchaseUnsafe(.success(.finished(transaction)))
                        }
                    case .failure(let error):
                        // 验单失败不能 finish，否则队列丢失，客户端无法凭未完成交易重试。
                        if self.isCurrentPurchase(transaction) {
                            self.completePurchaseUnsafe(.failure(.verificationFailed(error)))
                        }
                    }
                }
            }
        }
    }

    private func refreshReceiptUnsafe() {
        dispatchPrecondition(condition: .onQueue(syncQueue))
        guard !isRefreshingReceipt else { return }
        isRefreshingReceipt = true
        let request = SKReceiptRefreshRequest()
        request.delegate = self
        receiptRefreshRequest = request
        request.start()
    }

    private func retryTransactionsWaitingReceiptUnsafe() {
        dispatchPrecondition(condition: .onQueue(syncQueue))
        let pending = transactionsWaitingReceipt
        transactionsWaitingReceipt.removeAll()
        for transaction in pending {
            handlePurchasedUnsafe(transaction)
        }
    }

    private func failTransactionsWaitingReceiptUnsafe(_ error: AppleIAPError) {
        dispatchPrecondition(condition: .onQueue(syncQueue))
        let pending = transactionsWaitingReceipt
        transactionsWaitingReceipt.removeAll()
        for transaction in pending {
            if isCurrentPurchase(transaction) {
                completePurchaseUnsafe(.failure(error))
            }
        }
    }

    private func handleFailedUnsafe(_ transaction: SKPaymentTransaction) {
        dispatchPrecondition(condition: .onQueue(syncQueue))
        SKPaymentQueue.default().finishTransaction(transaction)
        guard isCurrentPurchase(transaction) else { return }
        if let error = transaction.error as? SKError, error.code == .paymentCancelled {
            completePurchaseUnsafe(.failure(.cancelled))
            return
        }
        if let error = transaction.error {
            completePurchaseUnsafe(.failure(.storeFailed(error)))
            return
        }
        completePurchaseUnsafe(.failure(.unknown))
    }

    private func handleDeferredUnsafe(_ transaction: SKPaymentTransaction) {
        dispatchPrecondition(condition: .onQueue(syncQueue))
        guard isCurrentPurchase(transaction) else { return }
        // 审批通过前不要 finish；成功后苹果会再次回调 .purchased。
        completePurchaseUnsafe(.success(.deferred(transaction)))
    }
}

// MARK: - SKProductsRequestDelegate / SKRequestDelegate

extension AppleIAPService: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        syncQueue.async { [weak self] in
            guard let self = self, request === self.productsRequest else { return }
            for product in response.products {
                self.productsById[product.productIdentifier] = product
            }
            let invalidIds = response.invalidProductIdentifiers
            let sorted = response.products.sorted { $0.price.doubleValue < $1.price.doubleValue }
            if sorted.isEmpty {
                if invalidIds.isEmpty {
                    self.completeFetchUnsafe(.failure(.emptyProducts))
                } else {
                    self.completeFetchUnsafe(.failure(.invalidProducts(invalidIds)))
                }
                return
            }
            self.completeFetchUnsafe(.success(AppleIAPProductsResult(
                products: sorted,
                invalidProductIdentifiers: invalidIds
            )))
        }
    }

    func requestDidFinish(_ request: SKRequest) {
        syncQueue.async { [weak self] in
            guard let self = self else { return }
            guard request === self.receiptRefreshRequest else { return }
            self.receiptRefreshRequest = nil
            self.isRefreshingReceipt = false
            if self.loadReceiptBase64() == nil {
                self.failTransactionsWaitingReceiptUnsafe(.missingReceipt)
                return
            }
            self.retryTransactionsWaitingReceiptUnsafe()
        }
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        syncQueue.async { [weak self] in
            guard let self = self else { return }
            if request === self.productsRequest {
                self.completeFetchUnsafe(.failure(.requestFailed(error)))
                return
            }
            if request === self.receiptRefreshRequest {
                self.receiptRefreshRequest = nil
                self.isRefreshingReceipt = false
                self.failTransactionsWaitingReceiptUnsafe(.receiptRefreshFailed(error))
            }
        }
    }
}

// MARK: - SKPaymentTransactionObserver

extension AppleIAPService: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        syncQueue.async { [weak self] in
            guard let self = self else { return }
            for transaction in transactions {
                switch transaction.transactionState {
                case .purchasing:
                    break
                case .purchased, .restored:
                    self.handlePurchasedUnsafe(transaction)
                case .failed:
                    self.handleFailedUnsafe(transaction)
                case .deferred:
                    self.handleDeferredUnsafe(transaction)
                @unknown default:
                    break
                }
            }
        }
    }

    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        syncQueue.async { [weak self] in
            self?.completeRestoreUnsafe(.success(()))
        }
    }

    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        syncQueue.async { [weak self] in
            self?.completeRestoreUnsafe(.failure(.restoreFailed(error)))
        }
    }

    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        if let handler = promotedPurchaseHandler {
            return handler(payment, product)
        }
        syncQueue.async { [weak self] in
            self?.pendingPromotedPayment = payment
        }
        return false
    }
}
