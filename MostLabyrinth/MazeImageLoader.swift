import SwiftUI

class MazeImageLoader {
    static var imageCache: [String: UIImage] = [:]
    
    static func loadImage(url: String) -> UIImage? {
        if let cachedImage = imageCache[url] {
            return cachedImage
        }
        
        guard let imageURL = URL(string: url),
              let data = try? Data(contentsOf: imageURL),
              let image = UIImage(data: data) else {
            return nil
        }
        
        imageCache[url] = image
        return image
    }
}

