import UIKit
import Kingfisher

/// 图片加载状态
enum HWebImageLoadStatus {
    case loading
    case success
    case failure
}

/// 图片来源
enum HWebImageSource {
    case local
    case network
    case origin
}

/// 用于在闭包中修改字符串值的引用类型包装器
final class StringBox {
    var value: String
    init(_ value: String) { self.value = value }
}

/// 图片加载状态回调
typealias HWebImageLoadStatusBlock = (AnyObject, HWebImageLoadStatus, Error?) -> Void

/// 图片获取回调
typealias HWebImageLoaderGetImageBlock = (AnyObject, UIImage?, HWebImageSource) -> Void

/// 图片加载器类
class HWebImageLoader {
    
    /// 预加载图片到缓存
    static func preloadImage(with url: URL) {
        let options: KingfisherOptionsInfo = [
            .cacheOriginalImage,
            .backgroundDecode,
            .scaleFactor(UIScreen.main.scale)
        ]
        
        KingfisherManager.shared.retrieveImage(with: url, options: options) { _ in
            // 预加载完成，不需要处理结果
        }
    }
    
    /// 批量预加载图片
    static func preloadImages(with urls: [URL]) {
        let options: KingfisherOptionsInfo = [
            .cacheOriginalImage,
            .backgroundDecode,
            .scaleFactor(UIScreen.main.scale)
        ]
        
        let group = DispatchGroup()
        for url in urls {
            group.enter()
            KingfisherManager.shared.retrieveImage(with: url, options: options) { _ in
                group.leave()
            }
        }
        
        // 非阻塞式等待，避免主线程卡顿
        group.notify(queue: .main) {
            // 预加载完成
        }
    }
    
    /// 预加载图片（使用URL字符串）
    static func preloadImage(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        preloadImage(with: url)
    }
    
    /// 批量预加载图片（使用URL字符串）
    static func preloadImages(with urlStrings: [String]) {
        let urls = urlStrings.compactMap { URL(string: $0) }
        preloadImages(with: urls)
    }
    
    /// 加载网络图片
    /// - Parameters:
    ///   - urlString: 图片URL字符串
    ///   - imageView: 要显示图片的UIImageView
    ///   - placeholder: 占位图片
    ///   - cropSize: 裁剪尺寸
    ///   - loadStatus: 加载状态回调
    ///   - getImage: 获取图片回调
    ///   - getError: 错误回调
    ///   - lastURL: 上次加载的URL
    /// - Returns: 上次加载的URL
    @discardableResult
    static func loadImage(with urlString: String, imageView: UIImageView, placeholder: UIImage? = nil, cropSize: CGSize = .zero, loadStatus: HWebImageLoadStatusBlock?, getImage: HWebImageLoaderGetImageBlock?, getError: ((AnyObject, AnyObject) -> Void)?, lastURLBox: StringBox? = nil) -> String {
        if urlString.isEmpty {
            imageView.image = placeholder
            loadStatus?(imageView, .failure, NSError(domain: "HWebImageLoader", code: 0, userInfo: [NSLocalizedDescriptionKey: "Empty URL"]))
            getError?(imageView, NSError(domain: "HWebImageLoader", code: 0, userInfo: [NSLocalizedDescriptionKey: "Empty URL"]))
            return ""
        }
        
        if !urlString.hasPrefix("http") {
            let image = UIImage(named: urlString)
            imageView.image = image
            loadStatus?(imageView, .success, nil)
            getImage?(imageView, image, .local)
            return urlString
        }
        
        if imageView.image != nil && lastURLBox?.value == urlString {
            loadStatus?(imageView, .success, nil)
            getImage?(imageView, imageView.image, .origin)
            return lastURLBox?.value ?? ""
        }

        lastURLBox?.value = ""
        
        guard let url = URL(string: urlString) else {
            loadStatus?(imageView, .failure, NSError(domain: "HWebImageLoader", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            getError?(imageView, NSError(domain: "HWebImageLoader", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return ""
        }
        
        var options = KingfisherOptionsInfo()
        options.append(.cacheOriginalImage)
        options.append(.scaleFactor(1))
        options.append(.backgroundDecode)
        options.append(.memoryCacheExpiration(.seconds(1800)))
        options.append(.diskCacheExpiration(.days(7)))
        
        options.append(.transition(ImageTransition.fade(0.3)))
        
        if cropSize != .zero {
            let processor = DownsamplingImageProcessor(size: cropSize)
            options.append(.processor(processor))
        }
        
        imageView.kf.setImage(with: url, placeholder: placeholder, options: options, completionHandler:  { result in
            switch result {
            case .success(let value):
                imageView.image = value.image
                lastURLBox?.value = urlString
                loadStatus?(imageView, .success, nil)
                getImage?(imageView, value.image, .network)
            case .failure(let error):
                loadStatus?(imageView, .failure, error)
                getError?(imageView, error as AnyObject)
            }
        })
        
        return ""
    }
    
    /// 加载本地图片
    /// - Parameters:
    ///   - fileName: 文件名
    ///   - imageView: 要显示图片的UIImageView
    static func loadLocalImage(with fileName: String, imageView: UIImageView) throws {
        if let filePath = Bundle.main.resourcePath?.appendingFormat("/%@", fileName),
           let image = UIImage(contentsOfFile: filePath) {
            imageView.image = image
        } else {
            throw NSError(domain: "HWebImageLoader", code: 2001, userInfo: [NSLocalizedDescriptionKey: "Local image not found: \(fileName)"])
        }
    }
    
    /// 加载Asset Catalog中的图片
    /// - Parameters:
    ///   - imageName: 图片名称
    ///   - imageView: 要显示图片的UIImageView
    static func loadAssetImage(with imageName: String, imageView: UIImageView) throws {
        if let image = UIImage(named: imageName) {
            imageView.image = image
        } else {
            throw NSError(domain: "HWebImageLoader", code: 2002, userInfo: [NSLocalizedDescriptionKey: "Asset image not found: \(imageName)"])
        }
    }
}
