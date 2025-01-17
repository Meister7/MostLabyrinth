import SwiftUI

enum LabyrinthType: CaseIterable {
    case labyrinth1
    case labyrinth2
    case labyrinth3
    
    
    func getImageName() -> String {
        switch self {
        case .labyrinth1:
            return "maze1" // Your PNG image names
        case .labyrinth2:
            return "maze2"
        case .labyrinth3:
            return "maze3"
        }
    }
}
//    func getWalls() -> [Wall] {
//        let width = UIScreen.main.bounds.width
//        let height = UIScreen.main.bounds.height
//        
//        switch self {
//        case .labyrinth1:  // Triangle
//            // Define the triangle corners using relative coordinates
//            let topPoint = CGPoint(x: 0.5, y: 0.2)  // Top center
//            let leftPoint = CGPoint(x: 0.3, y: 0.7)  // Bottom left
//            let rightPoint = CGPoint(x: 0.7, y: 0.7) // Bottom right
//            
//            return [
//                // Three sides of the triangle
//                Wall(start: leftPoint, end: topPoint),   // Left side
//                Wall(start: topPoint, end: rightPoint),  // Right side
//                Wall(start: rightPoint, end: leftPoint)  // Bottom side
//            ]
//            
//        case .labyrinth2:  // Polygon
//            // Define the polygon corners using relative coordinates
//            let points = [
//                CGPoint(x: 0.3, y: 0.2),   // Top left
//                CGPoint(x: 0.7, y: 0.2),   // Top right
//                CGPoint(x: 0.8, y: 0.5),   // Middle right
//                CGPoint(x: 0.7, y: 0.8),   // Bottom right
//                CGPoint(x: 0.3, y: 0.8),   // Bottom left
//                CGPoint(x: 0.2, y: 0.5)    // Middle left
//            ]
//            
//            var walls: [Wall] = []
//            // Connect all points to form the polygon
//            for i in 0..<points.count {
//                let start = points[i]
//                let end = points[(i + 1) % points.count]
//                walls.append(Wall(start: start, end: end))
//            }
//            return walls
//            
//        case .labyrinth3:  // Rectangle
//            // Define rectangle corners using relative coordinates
//            let topLeft = CGPoint(x: 0.2, y: 0.2)
//            let topRight = CGPoint(x: 0.8, y: 0.2)
//            let bottomRight = CGPoint(x: 0.8, y: 0.8)
//            let bottomLeft = CGPoint(x: 0.2, y: 0.8)
//            
//            return [
//                Wall(start: topLeft, end: topRight),       // Top
//                Wall(start: topRight, end: bottomRight),   // Right
//                Wall(start: bottomRight, end: bottomLeft), // Bottom
//                Wall(start: bottomLeft, end: topLeft)      // Left
//            ]
//        }
//    }
    


