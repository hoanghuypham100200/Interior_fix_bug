import Foundation

@propertyWrapper
struct UserDefaultWrapper<T: Codable> {
    let defaultValue: T
    let key: UserDefaultService.Key
    
    init(_ key: UserDefaultService.Key, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get { return UserDefaultService.shared.get(T.self, key: key.rawValue) ?? defaultValue }
        set { UserDefaultService.shared.set(T.self, value: newValue, key: key.rawValue) }
    }
}

final class UserDefaultService: NSObject {
    enum Key: String {
        case isFirstLaunch
        case isPurchase
        case isEnterBackground
        case isFirstHome
        case isFirstOpen        // check event tl_first_open
        case dsConfig
        case adsConfig          // lưu count show ds, app open ad, max creation
        case isCreateFolderImage
        case logoApp
        case ratingConfig
        case usage
        case configSetting
        case galleryPrompts
        case chatHistoryLogo //
    }
   
    static let shared: UserDefaultService = .init()
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    @UserDefaultWrapper(.isFirstLaunch, defaultValue: true)
    var isFirstLaunch: Bool
    
    @UserDefaultWrapper(.isPurchase, defaultValue: false)
    var isPurchase: Bool
    
    @UserDefaultWrapper(.isFirstHome, defaultValue: true)
    var isFirstHome: Bool
    
    @UserDefaultWrapper(.isEnterBackground, defaultValue: false)
    var isEnterBackground: Bool
    
    @UserDefaultWrapper(.isFirstOpen, defaultValue: true)
    var isFirstOpen: Bool
    
    @UserDefaultWrapper(.isCreateFolderImage, defaultValue: false)
    var isCreateFolderImage: Bool
    
    @UserDefaultWrapper(.ratingConfig, defaultValue: RatingPopConfigModel(isFirstHome: true, count_create: 1, canShow: false, didShow: false))
    var ratingConfig: RatingPopConfigModel
    
    @UserDefaultWrapper(.configSetting, defaultValue: ConfigSettingModel(ratioId: "", roomId: "", styleId: ""))
    var configSetting: ConfigSettingModel
    
    @UserDefaultWrapper(.dsConfig, defaultValue: DirectStoreConfigModel(type: "", close_button_delay: 0))
    var dsConfig: DirectStoreConfigModel
    
    @UserDefaultWrapper(.adsConfig, defaultValue: AdsModel(interstitialLastTime: 0, countShowDS: CountShowDSModel(count: 0, didSet: false), maxCreation: 0))
    var adsConfig: AdsModel
    
    @UserDefaultWrapper(.logoApp, defaultValue: "")
    var logoApp: String
    
    @UserDefaultWrapper(.usage, defaultValue: UsageModel(usageFreeCount: 0, usagePremiumCount: 0, usagePremiumLastTime: 0, isUpdatedDailyUsageWhenPurchase: false))
    var usage: UsageModel
    
    @UserDefaultWrapper(.galleryPrompts, defaultValue: [])
    var galleryPrompts: [ArtworkModel]
    
    
}

extension UserDefaultService {
    func get<T: Codable>(_ type: T.Type, key: String) -> T? {
        guard let str = UserDefaults.standard.string(forKey: key) else {
            return nil
        }
        guard let data = str.data(using: .utf8) else { return nil }
        return try? self.decoder.decode(T.self, from: data)
    }
    
    func set<T: Codable>(_ type: T.Type, value: T, key: String) {
        guard let data = try? encoder.encode(value) else { return }
        let str = String(data: data, encoding: .utf8)
        UserDefaults.standard.set(str, forKey: key)
    }
}
