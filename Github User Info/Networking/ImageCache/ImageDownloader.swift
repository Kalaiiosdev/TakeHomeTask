import UIKit

class ImageDownloader {
    static let shared = ImageDownloader()

    private let operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        return queue
    }()

    private init() {}

    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = ImageCache.shared.image(forKey: url.absoluteString) {
            completion(cachedImage)
            return
        }

        let operation = ImageDownloadOperation(url: url) { image in
            if let image = image {
                ImageCache.shared.setImage(image, forKey: url.absoluteString)
            }
            completion(image)
        }
        operationQueue.addOperation(operation)
    }
}

