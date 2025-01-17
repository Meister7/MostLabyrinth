import SwiftUI

struct MenuView: View {
    @StateObject private var orientationManager = OrientationManager()
    @Binding var screen: ScreenState
    @Binding var backgroundColor: Color?
    @Binding var selectedCharacter: String?
    let images: Images
    
    var body: some View {
        if orientationManager.isLandscape {
            ZStack {
                RemoteImage(url: images.backgroundLandscape)
                    .ignoresSafeArea()
                
                if backgroundColor != nil {
                    backgroundColor?.ignoresSafeArea(edges: .all)
                }
                VStack {
                    Button {
                        screen = .game
                    } label: {
                        RemoteImage(url: images.playBtn)
                            .scaledToFit()
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.25)
                    
                    Button {
                        screen = .labyrinth
                    } label: {
                        RemoteImage(url: images.labyrinthBtn)
                            .scaledToFit()
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.25)
                    
                    Button {
                        screen = .character
                    } label: {
                        RemoteImage(url: images.charBtn)
                            .scaledToFit()
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.25)
                    
                    Button {
                        screen = .music
                    } label: {
                        RemoteImage(url: images.musicBtn)
                            .scaledToFit()
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.25)
                    
                    Button {
                        screen = .policy
                    } label: {
                        RemoteImage(url: images.policyBtn)
                            .scaledToFit()
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.25)
                }
                .padding(.top, UIScreen.main.bounds.height * 0.1)
            }
        } else {
            ZStack {
                RemoteImage(url: images.background)
                    .ignoresSafeArea()
                
                if backgroundColor != nil {
                    backgroundColor?.ignoresSafeArea(edges: .all)
                }
                
                VStack {
                    Button {
                        screen = .game
                    } label: {
                        RemoteImage(url: images.playBtn)
                            .scaledToFit()
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.6)
                    
                    Button {
                        screen = .labyrinth
                    } label: {
                        RemoteImage(url: images.labyrinthBtn)
                            .scaledToFit()
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.6)
                    
                    Button {
                        screen = .character
                    } label: {
                        RemoteImage(url: images.charBtn)
                            .scaledToFit()
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.6)
                    
                    Button {
                        screen = .music
                    } label: {
                        RemoteImage(url: images.musicBtn)
                            .scaledToFit()
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.6)
                    
                    Button {
                        screen = .policy
                    } label: {
                        RemoteImage(url: images.policyBtn)
                            .scaledToFit()
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.6)
                }
                .padding(.bottom, UIScreen.main.bounds.height * 0.3)
            }
        }
    }
}
