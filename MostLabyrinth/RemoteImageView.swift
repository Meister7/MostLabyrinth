import SwiftUI

struct RemoteImage: View {
    let url: String
    @State private var image: UIImage? = nil
    
    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
        } else {
            ProgressView()
                .onAppear {
                    loadImage()
                }
        }
    }
    
    private func loadImage() {
        guard let imageUrl = URL(string: "https://mostlabyrinth.space\(url)") else { return }
        print(imageUrl)
        URLSession.shared.dataTask(with: imageUrl) { data, _, _ in
            if let data = data, let loadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = loadedImage
                }
            }
        }.resume()
    }
}
