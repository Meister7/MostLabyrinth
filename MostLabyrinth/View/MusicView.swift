import SwiftUI
import AVFoundation

struct MusicView: View {
    
    @StateObject private var orientationManager = OrientationManager()
    @Binding var screen: ScreenState
    @Binding var backgroundColor: Color?
    @State var isSoundOff: Bool = true
    @State private var backgroundAudioPlayer: AVAudioPlayer?
    let images: Images
    
    private let track = ["backgroundMusic"]
    
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
                    Spacer()
                    Button {
                        isSoundOff.toggle()
                        if isSoundOff {
                            stopBackgroundMusic()
                        } else {
                            playBackgroundMusic()
                        }
                    } label: {
                        if isSoundOff {
                            RemoteImage(url: images.musicOffBtn)
                                .scaledToFit()
                                .frame(width: UIScreen.main.bounds.width * 0.4)
                                .padding(.bottom, UIScreen.main.bounds.height * 0.4)
                        } else {
                            RemoteImage(url: images.musicOnBtn)
                                .scaledToFit()
                                .frame(width: UIScreen.main.bounds.width * 0.4)
                                .padding(.bottom, UIScreen.main.bounds.height * 0.4)
                        }
                    }
                }
            }
            .onAppear {
                setupAudioPlayer()
                if !isSoundOff {
                    playBackgroundMusic()
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
                        .padding(.top, UIScreen.main.bounds.height * 0.04 )
                        
                        Spacer()
                    }
                    
                    Spacer()
                    Button {
                        isSoundOff.toggle()
                        if isSoundOff {
                            stopBackgroundMusic()
                        } else {
                            playBackgroundMusic()
                        }
                    } label: {
                        if isSoundOff {
                            RemoteImage(url: images.musicOffBtn)
                                .scaledToFit()
                                .frame(width: UIScreen.main.bounds.width * 0.5)
                                .padding(.bottom, UIScreen.main.bounds.height * 0.5)
                        } else {
                            RemoteImage(url: images.musicOnBtn)
                                .scaledToFit()
                                .frame(width: UIScreen.main.bounds.width * 0.5)
                                .padding(.bottom, UIScreen.main.bounds.height * 0.5)
                        }
                    }
                    
                }
            }
            .onAppear {
                setupAudioPlayer()
                if !isSoundOff {
                    playBackgroundMusic()
                }
            }
        }
        
    }
    
    private func setupAudioPlayer() {
        let trackName = track[0]
        if let path = Bundle.main.path(forResource: trackName, ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                backgroundAudioPlayer = try AVAudioPlayer(contentsOf: url)
                backgroundAudioPlayer?.numberOfLoops = -1
                backgroundAudioPlayer?.prepareToPlay()
            } catch {
                print("Audio Player Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func playBackgroundMusic() {
        backgroundAudioPlayer?.play()
    }
    
    private func stopBackgroundMusic() {
        backgroundAudioPlayer?.stop()
        backgroundAudioPlayer?.currentTime = 0
    }
}

