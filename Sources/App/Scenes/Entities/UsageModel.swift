import Foundation

struct UsageModel: Codable {
    var usageFreeCount: Int
    var createUsagePremiumCount: Int
    var editUsagePremiumCount: Int
    var usagePremiumLastTime: Int
    var isUpdatedDailyUsageWhenPurchase: Bool
}
