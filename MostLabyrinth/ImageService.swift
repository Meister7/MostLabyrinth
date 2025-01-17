import Foundation
import Combine

class ImageService: ObservableObject {
    @Published var imageResponse: ImageResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    func fetchImages() {
        guard let url = URL(string: "https://mostlabyrinth.space") else {
            self.errorMessage = "Invalid URL"
            self.isLoading = false
            return
        }

        isLoading = true
        errorMessage = nil
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 15
        let session = URLSession(configuration: configuration)
        
        session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ImageResponse?.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = "Error: \(error.localizedDescription)"
                    self.imageResponse = nil
                case .finished:
                    break
                }
                self.isLoading = false
            }, receiveValue: { response in
                self.imageResponse = response
            })
            .store(in: &cancellables)
    }
}
