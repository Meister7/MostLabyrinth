import SwiftUI

struct ContentView: View {
    
    @Binding var screen: ScreenState
    @Binding var backgroundColor: Color?
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

