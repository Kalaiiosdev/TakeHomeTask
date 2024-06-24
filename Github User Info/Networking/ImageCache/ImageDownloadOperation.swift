import UIKit

class ImageDownloadOperation: Operation {
    private let url: URL
    private let completion: (UIImage?) -> Void

    init(url: URL, completion: @escaping (UIImage?) -> Void) {
        self.url = url
        self.completion = completion
        super.init()
    }

    override func main() {
        guard !isCancelled else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Failed to download image:", error?.localizedDescription ?? "Unknown error")
                self.completion(nil)
                return
            }

            if let image = UIImage(data: data) {
                self.completion(image)
            } else {
                print("Invalid image data")
                self.completion(nil)
            }
        }.resume()
    }
}

