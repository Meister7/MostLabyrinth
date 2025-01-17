import SwiftUI

struct CharacterView: View {
    
    @StateObject private var orientationManager = OrientationManager()
    @State private var currentPage = 0
    @Binding var screen: ScreenState
    @Binding var backgroundColor: Color?
    @Binding var selectedCharacter: String?
    let images: Images
    
    private let characters = [RemoteImage(url: "charM"), RemoteImage(url: "charO"), RemoteImage(url: "charS"), RemoteImage(url: "charT")]
    
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
                            RemoteImage(url: images.charM)
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
                            RemoteImage(url: images.charO)
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
                            RemoteImage(url: images.charS)
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
                        .frame(width: UIScreen.main.bounds.width * 0.28)
                        .tag(2)
                        
                        ZStack {
                            RemoteImage(url: images.charT)
                                .scaledToFit()
                            HStack {
                                RemoteImage(url: images.leftArrow)
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width * 0.03)
                                    .padding(.trailing, UIScreen.main.bounds.width * 0.5)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.28)
                        .tag(3)
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
                            RemoteImage(url: images.charM)
                                .scaledToFit()
                            HStack {
                                RemoteImage(url: images.rightArrow)
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width * 0.05)
                                    .padding(.leading, UIScreen.main.bounds.width * 0.8)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.7)
                        .tag(0)
                        
                        ZStack {
                            RemoteImage(url: images.charO)
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
                            RemoteImage(url: images.charS)
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
                        .frame(width: UIScreen.main.bounds.width * 0.68)
                        .tag(2)
                        
                        ZStack {
                            RemoteImage(url: images.charT)
                                .scaledToFit()
                            HStack {
                                RemoteImage(url: images.leftArrow)
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width * 0.05)
                                    .padding(.trailing, UIScreen.main.bounds.width * 0.8)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.68)
                        .tag(3)
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
        selectedCharacter = characters[currentPage].url
        print("Selected character: \(characters[currentPage])")
    }
}




