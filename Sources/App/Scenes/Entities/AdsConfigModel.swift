import Foundation

struct AdsConfigModel: Codable {
    let interstital: InterstitalAdModel
    let banner: BannerAdModel
    let rewarded: RewardedAdModel
    let appOpen: AppOpenAdModel
}

struct InterstitalAdModel: Codable {
    let enable: Bool
    let time: Int
}

struct BannerAdModel: Codable {
    let enable: Bool
}

struct RewardedAdModel: Codable {
    let enable: Bool
    let maxCreation: Int
}

struct AppOpenAdModel: Codable {
    let countShowDS: Int
}
