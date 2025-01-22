import SwiftUI

struct PolicyView: View {
    
    @StateObject private var orientationManager = OrientationManager()
    @Binding var screen: ScreenState
    @Binding var backgroundColor: Color?
    let images: Images
    
    var body: some View {
        if orientationManager.isLandscape {
            ZStack {
                WebView(url: URL(string: "https://www.freeprivacypolicy.com/live/233020fd-29b1-4f5b-b08b-690850885126")!)
                VStack {
                    HStack {
                        Button {
                            screen = .menu
                        } label: {
                            Image(systemName: "arrow.left.circle")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(Color.black)
                                .frame(width: UIScreen.main.bounds.width * 0.1)
                        }
                        Spacer()
                    }
                    Spacer()
                }
            }
        } else {
            ZStack {
                WebView(url: URL(string: "https://www.freeprivacypolicy.com/live/233020fd-29b1-4f5b-b08b-690850885126")!)
                VStack {
                    HStack {
                        Button {
                            screen = .menu
                        } label: {
                            Image(systemName: "arrow.left.circle")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(Color.black)
                                .frame(width: UIScreen.main.bounds.width * 0.1)
                        }
                        Spacer()
                    }
                    Spacer()
                
                }
            }
        }
    }
}

