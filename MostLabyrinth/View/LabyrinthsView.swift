import SwiftUI

struct LabyrinthsView: View {
    
    @StateObject private var orientationManager = OrientationManager()
    @State private var currentPage = 0
    @Binding var screen: ScreenState
    @Binding var backgroundColor: Color?
    @Binding var selectedMaze: String?
    let images: Images
    
    private let labyrinths = [RemoteImage(url: "maze1"), RemoteImage(url: "maze2"), RemoteImage(url: "maze3")]
    
    var body: some View {
        if orientationManager.isLandscape {
            ZStack {
                RemoteImage(url: images.backgroundLandscape2)
                    .ignoresSafeArea()
                
                if backgroundColor != nil {
                    backgroundColor?.ignoresSafeArea(edges: .all)
                }
                VStack {
                    HStack {
                        Button {
                            screen = .menu
                        } label: {
                            RemoteImage(url: images.leftArrow)
                                .scaledToFit()
                                .frame(width: UIScreen.main.bounds.width * 0.04)
                        }
                        .padding(.leading)
                        .padding(.top, UIScreen.main.bounds.height * 0.09)
                        
                        Spacer()
                    }
                    TabView(selection: $currentPage) {
                        ZStack {
                            RemoteImage(url: images.maze1)
                                .scaledToFit()
                            HStack {
                                RemoteImage(url: images.rightArrow)
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width * 0.03)
                                    .padding(.leading, UIScreen.main.bounds.width * 0.5)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.3)
                        .tag(0)
                        
                        ZStack {
                            RemoteImage(url: images.maze1)
                                .scaledToFit()
                            
                            HStack {
                                RemoteImage(url: images.rightArrow)
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width * 0.03)
                                    .padding(.leading, UIScreen.main.bounds.width * 0.5)
                            }
                            HStack {
                                RemoteImage(url: images.leftArrow)
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width * 0.03)
                                    .padding(.trailing, UIScreen.main.bounds.width * 0.5)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.27)
                        .tag(1)
                        
                        ZStack {
                            RemoteImage(url: images.maze3)
                                .scaledToFit()
                            HStack {
                                RemoteImage(url: images.leftArrow)
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width * 0.03)
                                    .padding(.trailing, UIScreen.main.bounds.width * 0.5)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.28)
                        .tag(2)
                    }
                    .padding(.top, UIScreen.main.bounds.height * 0.1)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    
                    Button(action: {
                        selectMaze()
                    }) {
                        RemoteImage(url: images.selectBtn)
                            .scaledToFit()
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.25)
                }
            }
        } else {
            ZStack {
                RemoteImage(url: images.background2)
                    .ignoresSafeArea()
                
                if backgroundColor != nil {
                    backgroundColor?.ignoresSafeArea(edges: .all)
                }
                VStack {
                    HStack {
                        Button {
                            screen = .menu
                        } label: {
                            RemoteImage(url: images.leftArrow)
                                .scaledToFit()
                                .frame(width: UIScreen.main.bounds.width * 0.06)
                        }
                        .padding(.leading)
                        .padding(.top, UIScreen.main.bounds.height * 0.04)
                        
                        Spacer()
                    }
                    TabView(selection: $currentPage) {
                        ZStack {
                            RemoteImage(url: images.maze1)
                                .scaledToFit()
                            HStack {
                                RemoteImage(url: images.rightArrow)
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width * 0.05)
                                    .padding(.leading, UIScreen.main.bounds.width * 0.6)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.7)
                        .tag(0)
                        
                        ZStack {
                            RemoteImage(url: images.maze2)
                                .scaledToFit()
                            
                            HStack {
                                RemoteImage(url: images.rightArrow)
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width * 0.05)
                                    .padding(.leading, UIScreen.main.bounds.width * 0.8)
                            }
                            HStack {
                                RemoteImage(url: images.leftArrow)
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width * 0.05)
                                    .padding(.trailing, UIScreen.main.bounds.width * 0.8)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.67)
                        .tag(1)
                        
                        ZStack {
                            RemoteImage(url: images.maze3)
                                .scaledToFit()
                            HStack {
                                RemoteImage(url: images.leftArrow)
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width * 0.05)
                                    .padding(.trailing, UIScreen.main.bounds.width * 0.8)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.68)
                        .tag(2)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    
                    Button(action: {
                        selectMaze()
                    }) {
                        RemoteImage(url: images.selectBtn)
                            .scaledToFit()
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.6)
                    .padding(.bottom, UIScreen.main.bounds.height * 0.2)
                }
            }
        }
    }
    
    private func selectMaze() {
        selectedMaze = labyrinths[currentPage].url
    }
}

