import Foundation

struct ResponseGenImageModel: Codable {
    let created: Int
    let data: [UrlModel]
}

struct UrlModel: Codable {
    let url: String
}
