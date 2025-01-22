import SwiftUI

enum LabyrinthType: CaseIterable {
    case labyrinth1
    case labyrinth2
    case labyrinth3
    
    
    func getImageName() -> String {
        switch self {
        case .labyrinth1:
            return "maze1"
        case .labyrinth2:
            return "maze2"
        case .labyrinth3:
            return "maze3"
        }
    }
}
