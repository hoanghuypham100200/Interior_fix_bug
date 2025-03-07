import Foundation

struct OnboardingItem: Codable {
    let title: String
    let description: String
    let thumb: String
}

struct OnboardingVersion: Codable {
    let version: String
    let data: [OnboardingItem]
}
