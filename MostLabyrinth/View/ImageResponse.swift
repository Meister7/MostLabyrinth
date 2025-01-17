import Foundation

struct ImageResponse: Codable {
    let images: Images
}

struct Images: Codable {
    let background: String
    let backgroundLandscape: String
    let background2: String
    let backgroundLandscape2: String
    let charBtn: String
    let charM: String
    let charO: String
    let charS: String
    let charT: String
    let gameTitle: String
    let gameTitle2: String
    let labyrinthBtn: String
    let leftArrow: String
    let maze1: String
    let maze2: String
    let maze3: String
    let mazeImg: String
    let musicBtn: String
    let musicOffBtn: String
    let musicOnBtn: String
    let nextBtn: String
    let playBtn: String
    let policyBtn: String
    let rightArrow: String
    let selectBtn: String
}
