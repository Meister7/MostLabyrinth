import UIKit

struct MazeImageLoader {
    static var imageCache: [String: UIImage] = [:]
    
    static func loadImage(url: String, completion: @escaping (UIImage?) -> Void) {
        let fullUrl = "https://mostlabyrinth.space\(url)"
        
        if let cachedImage = imageCache[fullUrl] {
            completion(cachedImage)
            return
        }
        
        guard let encodedURL = fullUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let imageURL = URL(string: encodedURL) else {
            print("Invalid URL: \(fullUrl)")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            if let error = error {
                print("Image loading error: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Failed to create UIImage from data")
                completion(nil)
                return
            }
            
            imageCache[fullUrl] = image
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
