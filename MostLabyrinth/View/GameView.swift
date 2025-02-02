import SwiftUI

struct GameView: View {
    
    @StateObject private var orientationManager = OrientationManager()
    @Binding var screen: ScreenState
    @Binding var backgroundColor: Color?
    @Binding var selectedMaze: String?
    @Binding var selectedCharacter: String?
    @State private var characterPosition = CGPoint(x: 0, y: 0)
    @State private var showButton: Bool = false
    @State private var timeRemaining: Int = 30
    
    let images: Images
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func resetTimer() {
        timeRemaining = 120 // Reset to 3 minutes
        showButton = false
    }
    
    private func getMazeImage(for maze: String) -> String {
        
        switch maze {
        case "maze1":
            return images.maze1
        case "maze2":
            return images.maze2
        case "maze3":
            return images.maze3
        default:
            return images.maze1
        }
    }
    private func getCharImage(for char: String) -> String {
        
        switch char {
        case "charM":
            return images.charM
        case "charO":
            return images.charO
        case "charS":
            return images.charS
        case "charT":
            return images.charT
        default:
            return images.charM
        }
    }
    
    func getPixelColor(image: UIImage, at point: CGPoint) -> UIColor? {
            guard let cgImage = image.cgImage,
                  let dataProvider = cgImage.dataProvider,
                  let pixelData = dataProvider.data as Data? else {
                print("Failed to get pixel data")
                return nil
            }
            
            let width = cgImage.width
            let height = cgImage.height
            let screenWidth = UIScreen.main.bounds.width
            let screenHeight = UIScreen.main.bounds.height
            
            // Adjusted coordinate mapping
            let mappedX = Int((point.x + screenWidth/2) / screenWidth * CGFloat(width))
            let mappedY = Int((point.y + screenHeight/2) / screenHeight * CGFloat(height))
            
            let safeX = max(0, min(width - 1, mappedX))
            let safeY = max(0, min(height - 1, mappedY))
            
            let bytesPerPixel = cgImage.bitsPerPixel / 8
            let pixelIndex = (safeY * width + safeX) * bytesPerPixel
            
            guard pixelIndex + bytesPerPixel <= pixelData.count else {
                print("Pixel index out of bounds")
                return nil
            }
            
            let red = CGFloat(pixelData[pixelIndex]) / 255.0
            let green = CGFloat(pixelData[pixelIndex + 1]) / 255.0
            let blue = CGFloat(pixelData[pixelIndex + 2]) / 255.0
            
            let pixelColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
            
            print("Pixel at (\(safeX), \(safeY)): \(pixelColor)")
            return pixelColor
        }

    func checkPixelColor(image: UIImage, position: CGPoint) -> Bool {
        guard let cgImage = image.cgImage else {
            print("Cannot get CGImage")
            return false
        }

        let width = cgImage.width
        let height = cgImage.height
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        // Improved coordinate mapping
        let mappedX = Int((position.x + screenWidth / 2) / screenWidth * CGFloat(width))
        let mappedY = Int((position.y + screenHeight / 2) / screenHeight * CGFloat(height))
        
        // Ensure coordinates are within bounds
        let safeX = max(0, min(width - 1, mappedX))
        let safeY = max(0, min(height - 1, mappedY))
        
        guard let provider = cgImage.dataProvider,
              let pixelData = provider.data,
              let data = CFDataGetBytePtr(pixelData) else {
            print("Failed to get pixel data")
            return false
        }
        
        let bytesPerPixel = cgImage.bitsPerPixel / 8
        let pixelInfo = ((width * safeY) + safeX) * bytesPerPixel
        
        let red = data[pixelInfo]
        let green = data[pixelInfo + 1]
        let blue = data[pixelInfo + 2]
        
        print("Color values at (\(safeX), \(safeY)): R:\(red), G:\(green), B:\(blue)")
        
        // Check if it's a wall (white)
        let isWall = red > 200 && green > 200 && blue > 200
        
        // Check if it's the background (blue)
        let isBackground = red < 50 && green < 50 && blue > 200
        
        // Can move only on black path
        let canMove = !isWall && !isBackground
        
        print("Is wall: \(isWall)")
        print("Is background: \(isBackground)")
        print("Can move: \(canMove)\n")
        
        return canMove
    }
    
    func debugImageLoading(url: String) {
        MazeImageLoader.loadImage(url: url) { image in
            guard let image = image else {
                print("Image failed to load: \(url)")
                return
            }
            
            print("Image successfully loaded")
            print("Image size: \(image.size)")
            print("Image scale: \(image.scale)")
            
            // Optional: Save image to verify
            if let data = image.pngData() {
                let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileURL = documentsPath.appendingPathComponent("debug_maze.png")
                try? data.write(to: fileURL)
                print("Image saved to: \(fileURL)")
            }
        }
    }
    
    func logMoveAttempt(newPosition: CGPoint, currentPosition: CGPoint, canMove: Bool) {
        print("Move attempt:")
        print("- From: \(currentPosition)")
        print("- To: \(newPosition)")
        print("- Can move: \(canMove)")
    }

    
    var body: some View {
        let defaultCharacter = "charM"
        let defaultMaze = "maze1"
        
        let characterToUse = selectedCharacter ?? defaultCharacter
        let labyrinthToUse = selectedMaze ?? defaultMaze
        
        let moveIncrement = UIScreen.main.bounds.width * 0.02
        
        if orientationManager.isLandscape {
            ZStack {
                RemoteImage(url: images.backgroundLandscape2)
                    .ignoresSafeArea()
                
                if backgroundColor != nil {
                    backgroundColor?.ignoresSafeArea(edges: .all)
                }
                
                HStack {
                    if let maze = selectedMaze {
                        ZStack {
                            RemoteImage(url: getMazeImage(for: labyrinthToUse))
                                .frame(width: UIScreen.main.bounds.width * 0.4)
                                .padding(.top, UIScreen.main.bounds.height * 0.1)
                            let offsets = getCharacterOffset(for: maze)
                            RemoteImage(url: getCharImage(for: characterToUse))
                                .scaledToFit()
                                .frame(width: UIScreen.main.bounds.width * 0.01)
                                .offset(x: characterPosition.x, y: characterPosition.y)
                            if showButton {
                                Button(action: {
                                    func resetTimer() {
                                        timeRemaining = 180 // Reset to 3 minutes
                                        showButton = false
                                    }
                                }) {
                                    RemoteImage(url: images.nextBtn)
                                        .scaledToFit()
                                        .frame(width: UIScreen.main.bounds.width * 0.5)
                                }
                                .position(x: UIScreen.main.bounds.width * 0.2,
                                          y: UIScreen.main.bounds.height * 0.1)
                            }
                        }
                        .padding(.leading)
                    } else {
                        ZStack {
                            RemoteImage(url: images.maze1)
                                .scaledToFit()
                                .frame(width: UIScreen.main.bounds.width * 0.4)
                                .foregroundColor(.white)
                            RemoteImage(url: images.charM)
                                .scaledToFit()
                                .frame(width: UIScreen.main.bounds.width * 0.01)
                                .offset(x: 0, y: UIScreen.main.bounds.height * 0.08)
                            if showButton {
                                Button(action: {
                                    resetTimer()
                                }) {
                                    RemoteImage(url: images.nextBtn)
                                        .scaledToFit()
                                        .frame(width: UIScreen.main.bounds.width * 0.5)
                                }
                                .position(x: UIScreen.main.bounds.width * 0.2,
                                          y: UIScreen.main.bounds.height * 0.1)
                            }
                        }
                        .padding(.leading)
                    }
                    
                    // Move Buttons Section (right side)
                    VStack {
                        // Diagonal Buttons (up-left, up-right)
                        HStack(spacing: 40) {
                            Button(action: {
                                let newPosition = CGPoint(x: characterPosition.x - moveIncrement, y: characterPosition.y - moveIncrement)
                                MazeImageLoader.loadImage(url: getMazeImage(for: labyrinthToUse)) { mazeImage in
                                        if let image = mazeImage {
                                            print("Attempting move to: \(newPosition)")
                                            let canMove = checkPixelColor(image: image, position: newPosition)
                                            if canMove {
                                                characterPosition = newPosition
                                            } else {
                                                print("Movement blocked - white pixel or out of bounds at: \(newPosition)")
                                            }
                                        }
                                    }
                            }) {
                                Text("↖").font(.title)
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40)
                            }
                            .offset(y: 60)
                            
                            Button(action: {
                                let newPosition = CGPoint(x: characterPosition.x + moveIncrement, y: characterPosition.y - moveIncrement)
                                MazeImageLoader.loadImage(url: getMazeImage(for: labyrinthToUse)) { mazeImage in
                                        if let image = mazeImage {
                                            print("Attempting move to: \(newPosition)")
                                            let canMove = checkPixelColor(image: image, position: newPosition)
                                            if canMove {
                                                characterPosition = newPosition
                                            } else {
                                                print("Movement blocked - white pixel or out of bounds at: \(newPosition)")
                                            }
                                        }
                                    }
                            }) {
                                Text("↗").font(.title)
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40)
                            }
                            .offset(y: 60)
                        }
                        
                        // Vertical Up and Down Buttons
                        VStack {
                            Button(action: {
                                let newPosition = CGPoint(x: characterPosition.x, y: characterPosition.y - moveIncrement)
                                MazeImageLoader.loadImage(url: getMazeImage(for: labyrinthToUse)) { mazeImage in
                                        if let image = mazeImage {
                                            print("Attempting move to: \(newPosition)")
                                            let canMove = checkPixelColor(image: image, position: newPosition)
                                            if canMove {
                                                characterPosition = newPosition
                                            } else {
                                                print("Movement blocked - white pixel or out of bounds at: \(newPosition)")
                                            }
                                        }
                                    }
                            }) {
                                Text("↑").font(.title)
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40)
                            }
                            
                            HStack(spacing: 50) { // Left and Right Buttons
                                Button(action: {
                                    let newPosition = CGPoint(x: characterPosition.x - moveIncrement, y: characterPosition.y)
                                    MazeImageLoader.loadImage(url: getMazeImage(for: labyrinthToUse)) { mazeImage in
                                            if let image = mazeImage {
                                                print("Attempting move to: \(newPosition)")
                                                let canMove = checkPixelColor(image: image, position: newPosition)
                                                if canMove {
                                                    characterPosition = newPosition
                                                } else {
                                                    print("Movement blocked - white pixel or out of bounds at: \(newPosition)")
                                                }
                                            }
                                        }
                                }) {
                                    Text("←").font(.title)
                                        .foregroundColor(.white)
                                        .frame(width: 40, height: 40)
                                }
                                Button(action: {
                                    let newPosition = CGPoint(x: characterPosition.x + moveIncrement, y: characterPosition.y)
                                    MazeImageLoader.loadImage(url: getMazeImage(for: labyrinthToUse)) { mazeImage in
                                            if let image = mazeImage {
                                                print("Attempting move to: \(newPosition)")
                                                let canMove = checkPixelColor(image: image, position: newPosition)
                                                if canMove {
                                                    characterPosition = newPosition
                                                } else {
                                                    print("Movement blocked - white pixel or out of bounds at: \(newPosition)")
                                                }
                                            }
                                        }
                                }) {
                                    Text("→").font(.title)
                                        .foregroundColor(.white)
                                        .frame(width: 40, height: 40)
                                }
                            }
                            
                            Button(action: {
                                let newPosition = CGPoint(x: characterPosition.x, y: characterPosition.y + moveIncrement)
                                MazeImageLoader.loadImage(url: getMazeImage(for: labyrinthToUse)) { mazeImage in
                                        if let image = mazeImage {
                                            print("Attempting move to: \(newPosition)")
                                            let canMove = checkPixelColor(image: image, position: newPosition)
                                            if canMove {
                                                characterPosition = newPosition
                                            } else {
                                                print("Movement blocked - white pixel or out of bounds at: \(newPosition)")
                                            }
                                        }
                                    }
                            }) {
                                Text("↓").font(.title)
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40)
                            }
                        }
                        
                        // Diagonal Buttons (down-left, down-right)
                        HStack(spacing: 40) {
                            Button(action: {
                                let newPosition = CGPoint(x: characterPosition.x - moveIncrement, y: characterPosition.y + moveIncrement)
                                MazeImageLoader.loadImage(url: getMazeImage(for: labyrinthToUse)) { mazeImage in
                                        if let image = mazeImage {
                                            print("Attempting move to: \(newPosition)")
                                            let canMove = checkPixelColor(image: image, position: newPosition)
                                            if canMove {
                                                characterPosition = newPosition
                                            } else {
                                                print("Movement blocked - white pixel or out of bounds at: \(newPosition)")
                                            }
                                        }
                                    }
                            }) {
                                Text("↙").font(.title)
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40)
                            }
                            .offset(y: -60)
                            
                            Button(action: {
                                let newPosition = CGPoint(x: characterPosition.x + moveIncrement, y: characterPosition.y + moveIncrement)
                                MazeImageLoader.loadImage(url: getMazeImage(for: labyrinthToUse)) { mazeImage in
                                        if let image = mazeImage {
                                            print("Attempting move to: \(newPosition)")
                                            let canMove = checkPixelColor(image: image, position: newPosition)
                                            if canMove {
                                                characterPosition = newPosition
                                            } else {
                                                print("Movement blocked - white pixel or out of bounds at: \(newPosition)")
                                            }
                                        }
                                    }
                            }) {
                                Text("↘").font(.title)
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40)
                            }
                            .offset(y: -60)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.4)
                    .padding(.trailing)
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
                }
            }
            .onReceive(timer) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                    if timeRemaining == 0 {
                        showButton = true
                    }
                }
            }
            .onAppear {
                if let maze = selectedMaze {
                    let offsets = getCharacterOffset(for: maze)
                    characterPosition = CGPoint(x: offsets.0, y: offsets.1)
                }
                if let maze = selectedMaze {
                        print("Selected maze: \(maze)")
                        print("Maze URL: \(getMazeImage(for: maze))")
                        let offsets = getCharacterOffset(for: maze)
                        characterPosition = CGPoint(x: offsets.0, y: offsets.1)
                    } else {
                        print("No maze selected")
                    }
                // Debug prints
                print("GameView appeared")
                print("Selected character: \(selectedCharacter ?? "none")")
                resetTimer()
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
                    Spacer()
                    
                    if let maze = selectedMaze {
                        ZStack {
                            RemoteImage(url: getCharImage(for: characterToUse))
                                .scaledToFit()
                                .frame(width: UIScreen.main.bounds.width * 0.02)
                                .offset(x: characterPosition.x, y: characterPosition.y)
                            RemoteImage(url: getMazeImage(for: labyrinthToUse))
                                .scaledToFit()
                                .frame(width: UIScreen.main.bounds.width )
                                .padding(.top, UIScreen.main.bounds.height * 0.1)
                                .foregroundStyle(.black)
                            let offsets = getCharacterOffset(for: maze)
                            if showButton {
                                Button(action: {
                                    resetTimer()
                                }) {
                                    RemoteImage(url: images.nextBtn)
                                        .scaledToFit()
                                        .frame(width: UIScreen.main.bounds.width * 0.5)
                                }
                                .position(x: UIScreen.main.bounds.width * 0.5,
                                          y: UIScreen.main.bounds.height * 0.3)
                            }
                        }
                        .padding(.bottom, UIScreen.main.bounds.height * 0.1)
                    } else {
                        ZStack {
                            RemoteImage(url: images.maze1)
                                .scaledToFit()
                                .frame(width: UIScreen.main.bounds.width * 0.9)
                                .padding(.top, UIScreen.main.bounds.height * 0.1)
                                .foregroundColor(.white)
                            RemoteImage(url: images.charM)
                                .scaledToFit()
                                .frame(width: UIScreen.main.bounds.width * 0.02)
                                .offset(x: characterPosition.x, y: characterPosition.y)
                            if showButton {
                                Button(action: {
                                    resetTimer()
                                }) {
                                    RemoteImage(url: images.nextBtn)
                                        .scaledToFit()
                                        .frame(width: UIScreen.main.bounds.width * 0.5)
                                }
                                .position(x: UIScreen.main.bounds.width * 0.5,
                                          y: UIScreen.main.bounds.height * 0.3)
                            }
                        }
                        .padding(.bottom, UIScreen.main.bounds.height * 0.1)
                    }
                    
                    //move buttons
                    VStack {
                        HStack(spacing: 40) { // Adjust the spacing here as needed
                            Button(action: {
                                let newPosition = CGPoint(x: characterPosition.x - moveIncrement, y: characterPosition.y - moveIncrement)
                                MazeImageLoader.loadImage(url: getMazeImage(for: labyrinthToUse)) { mazeImage in
                                        if let image = mazeImage {
                                            // Check multiple points around the intended position
                                            let margin: CGFloat = moveIncrement * 0.2 // 20% of move increment
                                            let checkPositions = [
                                                newPosition,
                                                CGPoint(x: newPosition.x + margin, y: newPosition.y),
                                                CGPoint(x: newPosition.x - margin, y: newPosition.y),
                                                CGPoint(x: newPosition.x, y: newPosition.y + margin),
                                                CGPoint(x: newPosition.x, y: newPosition.y - margin)
                                            ]
                                            
                                            // Only move if all check points are valid
                                            let canMove = checkPositions.allSatisfy { pos in
                                                checkPixelColor(image: image, position: pos)
                                            }
                                            
                                            if canMove {
                                                withAnimation(.linear(duration: 0.1)) {
                                                    characterPosition = newPosition
                                                }
                                            } else {
                                                print("Movement blocked - wall or background detected")
                                            }
                                        }
                                    }
                            }) {
                                Text("↖").font(.title)
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40)
                            }
                            .offset(y: 60)
                            Button(action: {
                                let newPosition = CGPoint(x: characterPosition.x + moveIncrement, y: characterPosition.y - moveIncrement)
                                MazeImageLoader.loadImage(url: getMazeImage(for: labyrinthToUse)) { mazeImage in
                                        if let image = mazeImage {
                                            // Check multiple points around the intended position
                                            let margin: CGFloat = moveIncrement * 0.2 // 20% of move increment
                                            let checkPositions = [
                                                newPosition,
                                                CGPoint(x: newPosition.x + margin, y: newPosition.y),
                                                CGPoint(x: newPosition.x - margin, y: newPosition.y),
                                                CGPoint(x: newPosition.x, y: newPosition.y + margin),
                                                CGPoint(x: newPosition.x, y: newPosition.y - margin)
                                            ]
                                            
                                            // Only move if all check points are valid
                                            let canMove = checkPositions.allSatisfy { pos in
                                                checkPixelColor(image: image, position: pos)
                                            }
                                            
                                            if canMove {
                                                withAnimation(.linear(duration: 0.1)) {
                                                    characterPosition = newPosition
                                                }
                                            } else {
                                                print("Movement blocked - wall or background detected")
                                            }
                                        }
                                    }
                            }) {
                                Text("↗").font(.title)
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40)
                            }
                            .offset(y: 60)
                            
                        }
                        // Vertical up and down buttons
                        VStack { // Add space between buttons
                            Button(action: {
                                let newPosition = CGPoint(x: characterPosition.x, y: characterPosition.y - moveIncrement)
                                MazeImageLoader.loadImage(url: getMazeImage(for: labyrinthToUse)) { mazeImage in
                                        if let image = mazeImage {
                                            // Check multiple points around the intended position
                                            let margin: CGFloat = moveIncrement * 0.2 // 20% of move increment
                                            let checkPositions = [
                                                newPosition,
                                                CGPoint(x: newPosition.x + margin, y: newPosition.y),
                                                CGPoint(x: newPosition.x - margin, y: newPosition.y),
                                                CGPoint(x: newPosition.x, y: newPosition.y + margin),
                                                CGPoint(x: newPosition.x, y: newPosition.y - margin)
                                            ]
                                            
                                            // Only move if all check points are valid
                                            let canMove = checkPositions.allSatisfy { pos in
                                                checkPixelColor(image: image, position: pos)
                                            }
                                            
                                            if canMove {
                                                withAnimation(.linear(duration: 0.1)) {
                                                    characterPosition = newPosition
                                                }
                                            } else {
                                                print("Movement blocked - wall or background detected")
                                            }
                                        }
                                    }
                            }) {
                                Text("↑").font(.title)
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40)
                            }
                            
                            HStack(spacing: 50) { // Horizontal left and right buttons with spacing
                                Button(action: {
                                    let newPosition = CGPoint(x: characterPosition.x - moveIncrement, y: characterPosition.y)
                                    MazeImageLoader.loadImage(url: getMazeImage(for: labyrinthToUse)) { mazeImage in
                                            if let image = mazeImage {
                                                // Check multiple points around the intended position
                                                let margin: CGFloat = moveIncrement * 0.2 // 20% of move increment
                                                let checkPositions = [
                                                    newPosition,
                                                    CGPoint(x: newPosition.x + margin, y: newPosition.y),
                                                    CGPoint(x: newPosition.x - margin, y: newPosition.y),
                                                    CGPoint(x: newPosition.x, y: newPosition.y + margin),
                                                    CGPoint(x: newPosition.x, y: newPosition.y - margin)
                                                ]
                                                
                                                // Only move if all check points are valid
                                                let canMove = checkPositions.allSatisfy { pos in
                                                    checkPixelColor(image: image, position: pos)
                                                }
                                                
                                                if canMove {
                                                    withAnimation(.linear(duration: 0.1)) {
                                                        characterPosition = newPosition
                                                    }
                                                } else {
                                                    print("Movement blocked - wall or background detected")
                                                }
                                            }
                                        }
                                }) {
                                    Text("←").font(.title)
                                        .foregroundColor(.white)
                                        .frame(width: 40, height: 40)
                                }
                                Button(action: {
                                    let newPosition = CGPoint(x: characterPosition.x + moveIncrement, y: characterPosition.y)
                                    MazeImageLoader.loadImage(url: getMazeImage(for: labyrinthToUse)) { mazeImage in
                                            if let image = mazeImage {
                                                // Check multiple points around the intended position
                                                let margin: CGFloat = moveIncrement * 0.2 // 20% of move increment
                                                let checkPositions = [
                                                    newPosition,
                                                    CGPoint(x: newPosition.x + margin, y: newPosition.y),
                                                    CGPoint(x: newPosition.x - margin, y: newPosition.y),
                                                    CGPoint(x: newPosition.x, y: newPosition.y + margin),
                                                    CGPoint(x: newPosition.x, y: newPosition.y - margin)
                                                ]
                                                
                                                // Only move if all check points are valid
                                                let canMove = checkPositions.allSatisfy { pos in
                                                    checkPixelColor(image: image, position: pos)
                                                }
                                                
                                                if canMove {
                                                    withAnimation(.linear(duration: 0.1)) {
                                                        characterPosition = newPosition
                                                    }
                                                } else {
                                                    print("Movement blocked - wall or background detected")
                                                }
                                            }
                                        }
                                }) {
                                    Text("→").font(.title)
                                        .foregroundColor(.white)
                                        .frame(width: 40, height: 40)
                                }
                            }
                            
                            Button(action: {
                                let newPosition = CGPoint(x: characterPosition.x, y: characterPosition.y + moveIncrement)
                                MazeImageLoader.loadImage(url: getMazeImage(for: labyrinthToUse)) { mazeImage in
                                        if let image = mazeImage {
                                            // Check multiple points around the intended position
                                            let margin: CGFloat = moveIncrement * 0.2 // 20% of move increment
                                            let checkPositions = [
                                                newPosition,
                                                CGPoint(x: newPosition.x + margin, y: newPosition.y),
                                                CGPoint(x: newPosition.x - margin, y: newPosition.y),
                                                CGPoint(x: newPosition.x, y: newPosition.y + margin),
                                                CGPoint(x: newPosition.x, y: newPosition.y - margin)
                                            ]
                                            
                                            // Only move if all check points are valid
                                            let canMove = checkPositions.allSatisfy { pos in
                                                checkPixelColor(image: image, position: pos)
                                            }
                                            
                                            if canMove {
                                                withAnimation(.linear(duration: 0.1)) {
                                                    characterPosition = newPosition
                                                }
                                            } else {
                                                print("Movement blocked - wall or background detected")
                                            }
                                        }
                                    }
                            }) {
                                Text("↓").font(.title)
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40)
                            }
                        }
                        
                        // Diagonal buttons with spacing between them
                        
                        HStack(spacing: 40) { // Adjust the spacing here as needed
                            Button(action: {
                                let newPosition = CGPoint(x: characterPosition.x - moveIncrement, y: characterPosition.y + moveIncrement)
                                MazeImageLoader.loadImage(url: getMazeImage(for: labyrinthToUse)) { mazeImage in
                                        if let image = mazeImage {
                                            // Check multiple points around the intended position
                                            let margin: CGFloat = moveIncrement * 0.2 // 20% of move increment
                                            let checkPositions = [
                                                newPosition,
                                                CGPoint(x: newPosition.x + margin, y: newPosition.y),
                                                CGPoint(x: newPosition.x - margin, y: newPosition.y),
                                                CGPoint(x: newPosition.x, y: newPosition.y + margin),
                                                CGPoint(x: newPosition.x, y: newPosition.y - margin)
                                            ]
                                            
                                            // Only move if all check points are valid
                                            let canMove = checkPositions.allSatisfy { pos in
                                                checkPixelColor(image: image, position: pos)
                                            }
                                            
                                            if canMove {
                                                withAnimation(.linear(duration: 0.1)) {
                                                    characterPosition = newPosition
                                                }
                                            } else {
                                                print("Movement blocked - wall or background detected")
                                            }
                                        }
                                    }
                            }) {
                                Text("↙").font(.title)
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40)
                            }
                            .offset(y: -60)
                            Button(action: {
                                let newPosition = CGPoint(x: characterPosition.x + moveIncrement, y: characterPosition.y + moveIncrement)
                                MazeImageLoader.loadImage(url: getMazeImage(for: labyrinthToUse)) { mazeImage in
                                        if let image = mazeImage {
                                            // Check multiple points around the intended position
                                            let margin: CGFloat = moveIncrement * 0.2 // 20% of move increment
                                            let checkPositions = [
                                                newPosition,
                                                CGPoint(x: newPosition.x + margin, y: newPosition.y),
                                                CGPoint(x: newPosition.x - margin, y: newPosition.y),
                                                CGPoint(x: newPosition.x, y: newPosition.y + margin),
                                                CGPoint(x: newPosition.x, y: newPosition.y - margin)
                                            ]
                                            
                                            // Only move if all check points are valid
                                            let canMove = checkPositions.allSatisfy { pos in
                                                checkPixelColor(image: image, position: pos)
                                            }
                                            
                                            if canMove {
                                                withAnimation(.linear(duration: 0.1)) {
                                                    characterPosition = newPosition
                                                }
                                            } else {
                                                print("Movement blocked - wall or background detected")
                                            }
                                        }
                                    }
                            }) {
                                Text("↘").font(.title)
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40)
                            }
                            .offset(y: -60)
                        }
                        .padding(.bottom, UIScreen.main.bounds.height * 0.01)
                    }
                }
            }
            .onReceive(timer) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                    if timeRemaining == 0 {
                        showButton = true
                    }
                }
            }
            .onAppear {
                if let maze = selectedMaze {
                    let offsets = getCharacterOffset(for: maze)
                    characterPosition = CGPoint(x: offsets.0, y: offsets.1)
                }
                if let maze = selectedMaze {
                        print("Selected maze: \(maze)")
                        print("Maze URL: \(getMazeImage(for: maze))")
                        let offsets = getCharacterOffset(for: maze)
                        characterPosition = CGPoint(x: offsets.0, y: offsets.1)
                    } else {
                        print("No maze selected")
                    }
                if let maze = selectedMaze {
                       debugImageLoading(url: getMazeImage(for: maze))
                   }
                // Debug prints
                print("GameView appeared")
                print("Selected character: \(selectedCharacter ?? "none")")
                resetTimer()
            }
        }
    }
}
private func getCharacterOffset(for maze: String) -> (CGFloat, CGFloat) {
    switch maze {
    case "maze1":
        return (0, UIScreen.main.bounds.height * 0.08)
    case "maze2":
        return (-UIScreen.main.bounds.width * 0.15, UIScreen.main.bounds.height * -0.053) // Adjust these values
    case "maze3":
        return (-UIScreen.main.bounds.width * 0.43, UIScreen.main.bounds.height * -0.071)// Adjust these values
    default:
        return (0, UIScreen.main.bounds.height * 0.08)
    }
}
