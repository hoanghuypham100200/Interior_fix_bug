import Foundation

struct AdsModel: Codable {
    var interstitialLastTime: Int       // Last time interstitial ad
    var countShowDS: CountShowDSModel   // Count show ds app open ad
    var maxCreation: Int
}

struct CountShowDSModel: Codable {
    var count: Int
    var didSet: Bool
}
