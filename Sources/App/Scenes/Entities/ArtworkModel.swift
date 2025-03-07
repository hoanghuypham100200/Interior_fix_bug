import UIKit

struct ArtworkModel: Codable {
    let id: String
    var style: String
    let prompt: String
    let room: String
    var url: String
}
