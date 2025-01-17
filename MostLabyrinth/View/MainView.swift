import SwiftUI
import WebKit

enum ScreenState {
    case menu, game, labyrinth, character, music, policy
}

struct MainView: View {
    
    @State var screenState: ScreenState = .menu
    @State var selectedColor: Color?
    @State private var selectedCharacter: String?
    @State private var selectedMaze: String?
    @State var isMuted: Bool = false
    @StateObject private var imageService = ImageService()
    @State private var isConnectedToInternet = true
    
    init() {
        checkInternetConnection()
    }
    
    var body: some View {
        ZStack {
            if !isConnectedToInternet {
                VStack {
                    Text("No internet connection. Please check your network and try again.")
                        .multilineTextAlignment(.center)
                        .padding()
                    Button("Retry") {
                        checkInternetConnection()
                        imageService.fetchImages()
                    }
                }
            } else if let images = imageService.imageResponse?.images {
                switch screenState {
                case .menu:
                    MenuView(screen: $screenState, backgroundColor: $selectedColor, selectedCharacter: $selectedCharacter, images: images)
                case .game:
                    GameView(screen: $screenState, backgroundColor: $selectedColor, selectedMaze: $selectedMaze, selectedCharacter: $selectedCharacter, images: images)
                case .labyrinth:
                    LabyrinthsView(screen: $screenState, backgroundColor: $selectedColor, selectedMaze: $selectedMaze, images: images)
                case .character:
                    CharacterView(screen: $screenState, backgroundColor: $selectedColor, selectedCharacter: $selectedCharacter, images: images)
                case .music:
                    MusicView(screen: $screenState, backgroundColor: $selectedColor, images: images)
                case .policy:
                    PolicyView(screen: $screenState, backgroundColor: $selectedColor, images: images)
                }
            } else if imageService.isLoading {
                VStack {
                    ProgressView("Loading...")
                        .padding()
                    Text("Please wait")
                }
            } else {
                WebView(url: URL(string: "https://mostlabyrinth.space")!)
            }
        }
        .onAppear {
            if imageService.imageResponse == nil && !imageService.isLoading {
                checkInternetConnection()
                imageService.fetchImages()
            }
        }
    }
    
    private func checkInternetConnection() {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "InternetConnectionMonitor")
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                isConnectedToInternet = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}

#Preview {
    MainView()
}
