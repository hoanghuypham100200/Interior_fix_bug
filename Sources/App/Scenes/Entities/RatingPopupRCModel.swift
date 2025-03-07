import Foundation

struct RatingPopupRCModel: Codable {
    let home: RatingHomeModel
    let call_api: CallAPIModel
}

struct RatingHomeModel: Codable {
    let enable: Bool
}

struct CallAPIModel: Codable {
    let enable: Bool
    let count: Int
}
