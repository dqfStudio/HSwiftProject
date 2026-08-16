import UIKit
import Kingfisher

enum HImageLoadStatus {
    case loading
    case success
    case failure
}

enum HImageSource {
    case local
    case network
    case origin
    case cache
}

final class HImageTextURLBox {
    var value: String
    var token: UInt = 0
    init(_ value: String) { self.value = value }

    func invalidate() {
        value = ""
        token += 1
    }
}

typealias HImageLoadStatusBlock = (AnyObject, HImageLoadStatus, Error?) -> Void
typealias HImageTextLoaderGetImageBlock = (AnyObject, UIImage?, HImageSource) -> Void

enum HImageTextLoader {

    static func preloadImage(with url: URL) {
        KingfisherManager.shared.retrieveImage(with: url, options: preloadOptions) { _ in }
    }

    static func preloadImages(with urls: [URL]) {
        for url in urls {
            preloadImage(with: url)
        }
    }

    static func preloadImage(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        preloadImage(with: url)
    }

    static func preloadImages(with urlStrings: [String]) {
        preloadImages(with: urlStrings.compactMap { URL(string: $0) })
    }

    @discardableResult
    static func loadImage(
        with urlString: String,
        imageView: UIImageView,
        placeholder: UIImage? = nil,
        cropSize: CGSize = .zero,
        syncLoadCache: Bool = false,
        loadStatus: HImageLoadStatusBlock?,
        getImage: HImageTextLoaderGetImageBlock?,
        getError: ((AnyObject, AnyObject) -> Void)?,
        lastURLBox: HImageTextURLBox? = nil
    ) -> String {
        if urlString.isEmpty {
            imageView.kf.cancelDownloadTask()
            lastURLBox?.invalidate()
            imageView.image = placeholder
            let error = loaderError("Empty URL", code: 0)
            loadStatus?(imageView, .failure, error)
            getError?(imageView, error)
            return ""
        }

        if !isRemoteURL(urlString) {
            imageView.kf.cancelDownloadTask()
            if let image = UIImage(named: urlString) {
                lastURLBox?.value = urlString
                imageView.image = image
                loadStatus?(imageView, .success, nil)
                getImage?(imageView, image, .local)
                return urlString
            }
            lastURLBox?.invalidate()
            imageView.image = placeholder
            let error = loaderError("Asset image not found: \(urlString)", code: 2002)
            loadStatus?(imageView, .failure, error)
            getError?(imageView, error)
            return ""
        }

        if imageView.image != nil, lastURLBox?.value == urlString {
            loadStatus?(imageView, .success, nil)
            getImage?(imageView, imageView.image, .origin)
            return urlString
        }

        guard let url = URL(string: urlString) else {
            imageView.kf.cancelDownloadTask()
            lastURLBox?.invalidate()
            let error = loaderError("Invalid URL", code: 0)
            loadStatus?(imageView, .failure, error)
            getError?(imageView, error)
            return ""
        }

        lastURLBox?.token += 1
        let requestToken = lastURLBox?.token

        if syncLoadCache, let cached = KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: url.cacheKey) {
            imageView.kf.cancelDownloadTask()
            lastURLBox?.value = urlString
            imageView.image = cached
            loadStatus?(imageView, .success, nil)
            getImage?(imageView, cached, .cache)
            return urlString
        }

        var options = KingfisherOptionsInfo()
        let scale = imageView.traitCollection.displayScale
        options.append(.cacheOriginalImage)
        options.append(.scaleFactor(scale > 0 ? scale : UIScreen.main.scale))
        options.append(.backgroundDecode)
        options.append(.memoryCacheExpiration(.seconds(1800)))
        options.append(.diskCacheExpiration(.days(7)))
        options.append(.transition(.fade(0.3)))

        if cropSize != .zero {
            options.append(.processor(DownsamplingImageProcessor(size: cropSize)))
        }

        imageView.kf.setImage(with: url, placeholder: placeholder, options: options) { result in
            guard lastURLBox == nil || lastURLBox?.token == requestToken else { return }
            switch result {
            case .success(let value):
                lastURLBox?.value = urlString
                imageView.image = value.image
                let source: HImageSource = value.cacheType == .none ? .network : .cache
                loadStatus?(imageView, .success, nil)
                getImage?(imageView, value.image, source)
            case .failure(let error):
                lastURLBox?.value = ""
                loadStatus?(imageView, .failure, error)
                getError?(imageView, error as AnyObject)
            }
        }

        return urlString
    }

    static func loadLocalImage(with fileName: String, imageView: UIImageView) throws {
        if let filePath = Bundle.main.resourcePath?.appendingFormat("/%@", fileName),
           let image = UIImage(contentsOfFile: filePath) {
            imageView.image = image
        } else {
            throw loaderError("Local image not found: \(fileName)", code: 2001)
        }
    }

    static func loadAssetImage(with imageName: String, imageView: UIImageView) throws {
        if let image = UIImage(named: imageName) {
            imageView.image = image
        } else {
            throw loaderError("Asset image not found: \(imageName)", code: 2002)
        }
    }

    static func isRemoteURL(_ urlString: String) -> Bool {
        let lower = urlString.lowercased()
        return lower.hasPrefix("http://") || lower.hasPrefix("https://")
    }

    private static var preloadOptions: KingfisherOptionsInfo {
        let scale = UITraitCollection.current.displayScale
        return [
            .cacheOriginalImage,
            .backgroundDecode,
            .scaleFactor(scale > 0 ? scale : UIScreen.main.scale)
        ]
    }

    private static func loaderError(_ message: String, code: Int) -> NSError {
        NSError(domain: "HImageTextLoader", code: code, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
