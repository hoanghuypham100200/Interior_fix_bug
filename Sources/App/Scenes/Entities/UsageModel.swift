import Foundation

struct UsageModel: Codable {
    var usageFreeCount: Int
    var usagePremiumCount: Int
    var usagePremiumLastTime: Int
    var isUpdatedDailyUsageWhenPurchase: Bool
}
