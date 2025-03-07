import UIKit
import StoreKit
import Alamofire

struct Developer {
    // MARK: Information app
    static let itcAppID = "6470359277"
    static let urlApp = "https://apps.apple.com/vn/app/id\(Developer.itcAppID)"
    static let supportEmail = "admin@tinyleo.com"
    static let conntacUs = "https://sites.google.com/tinyleo.com/contact-us"
    static let privacyPolicy = "https://sites.google.com/tinyleo.com/privacy-policy"
    static let termOfUse = "https://sites.google.com/tinyleo.com/terms-of-use"
    static let bundleID = Bundle.main.bundleIdentifier!
    static let appName = "ArchAI"
    
    // MARK: RC
    // Value này để check show open app ở delegate.
    static var didGetRC = false
    
    // folder save artwork
    static let folderHistoryArtwork = "HistoryArtWork"
    
    static var isGenArtByAd = false
    static var isShowMenu = false
    static var valueSearch = ""
    static var loadMoreRemainning = 0
    static var pickedCateID = ""
    
    // MARK: Replace text
    static let replaceUserInput = "userinput"
    static let replaceRoom = "roomtype"
    
    // MARK: Role
    static let roleSystem = "system"
    static let roleUser = "user"
    
    // MARK: Ad
    static var didShowInterstitialAd = true
    
    // MARK: Qonversion
    static let qonversionKey = "WMoLosiWSH3MmdDsQuFKkPKVLJeujg97"
    static let weeklyTrialID = "weeklytrial"
    static let yearlyID = "yearly"
    static let weeklyID = "weekly"
    
    // MARK: Local key
    static let localKey = ""
    
    // MARK: API Client
    static let bearer = "Bearer "
    
    static let ratio = UIScreen.main.bounds.width / 375.0
    static let isHasNortch: Bool = {
        let size = UIScreen.main.bounds.size
        return size.width / size.height < 375.0 / 667.0
    }()
    
#if DEBUG && canImport(GoogleMobileAds)
    static let testDevices: [String] = ["kGADSimulatorID"]
#else
    static let testDevices: [String] = []
#endif
    
}

struct AdMob {
    // Banner
    static var bannerAdId: String {
#if DEBUG
        return "ca-app-pub-3940256099942544/2934735716"
#else
        return "ca-app-pub-4867765339642009/1975560132"
#endif
    }
    
    // App open
    static var appOpenAdId: String {
#if DEBUG
        return "ca-app-pub-3940256099942544/5575463023"
#else
        return "ca-app-pub-4867765339642009/3484111798"
#endif
    }
    
    // Rewarded
    static var rewardedAdHighId: String {
#if DEBUG
        return "ca-app-pub-3940256099942544/1712485313"
#else
        return "ca-app-pub-4867765339642009/7875515469"
#endif
    }
    
    static var rewardedAdMediumId: String {
#if DEBUG
        return "ca-app-pub-3940256099942544/1712485313"
#else
        return "ca-app-pub-4867765339642009/5587502080"
#endif
    }

    // Interstitial
    static var interstitialAdHighId: String {
#if DEBUG
        return "ca-app-pub-3940256099942544/1033173712"
#else
        return "ca-app-pub-4867765339642009/1759966581"
#endif
    }
    
    static var interstitialAdMediumId: String {
#if DEBUG
        return "ca-app-pub-3940256099942544/1033173712"
#else
        return "ca-app-pub-4867765339642009/4849135480"
#endif
    }
}

enum DirectStoreType: String, Codable {
    case directstoreV1 = "directstore_v1"
    case directstoreV2 = "directstore_v2"
}

enum OnboardingType: String, Codable {
    case onboardingV1 = "onboarding_v1"
}
