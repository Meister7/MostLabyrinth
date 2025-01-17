import SwiftUI

struct PolicyView: View {
    
    @StateObject private var orientationManager = OrientationManager()
    @Binding var screen: ScreenState
    @Binding var backgroundColor: Color?
    let images: Images
    
    var body: some View {
        if orientationManager.isLandscape {
            ZStack {
                Image("backgroundLandscape2")
                    .resizable()
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
                    Text("-Easy to play: swipe to control the letter in the maze and find the exit; -Simple and relaxing: relax with small mazes or try to solve more complex ones.")
                        .foregroundStyle(.white)
                        .font(.system(size: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize, weight: .bold))
                        .padding(.bottom, UIScreen.main.bounds.height * 0.2)
                }
            }
        } else {
            ZStack {
                Image("background2")
                    .resizable()
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
                    Text("-Easy to play: swipe to control the letter in the maze and find the exit; -Simple and relaxing: relax with small mazes or try to solve more complex ones.")
                        .foregroundStyle(.white)
                        .font(.system(size: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize, weight: .bold))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, UIScreen.main.bounds.height * 0.5)
                }
            }
        }
    }
}

