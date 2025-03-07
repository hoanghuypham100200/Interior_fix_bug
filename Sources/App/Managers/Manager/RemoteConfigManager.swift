import Foundation
import UIKit
import RxCocoa
import RxSwift
import FirebaseRemoteConfig

protocol RemoteConfigManager {
    // MARK: API Configs
    // Api endpoint
    var apiEndpointOsb: Observable<APIEndPointModel> { get }
    var apiEndpointValue: APIEndPointModel { get }
    
    // api key
    var apiKeyOsb: Observable<String> { get }
    var apiKeyValue: String { get }
    
    // is Using Local Key
    var isUsingLocalKeyOsb: Observable<Bool> { get }
    var isUsingLocalKeyValue: Bool { get }
    
    var fluxModelConfigOsb: Observable<FluxConfigModel> { get }
    var fluxModelConfigValue: FluxConfigModel { get }
    var fluxFillDevModelConfigValue: FluxFillDevConfigModel { get }

    // Limit
    var limitConfigOsb: Observable<LimitConfigModel> { get }
    var limitConfigValue: LimitConfigModel { get }
    
    // MARK: Configs
    // Rating
    var ratingConfig: Observable<RatingPopupRCModel> { get }
    var ratingConfigValue: RatingPopupRCModel { get }
    
    var ratioConfigOsb: Observable<[RatioConfigModel]> { get }
    var ratioConfigValue: [RatioConfigModel] { get }
    
    var styleConfigOsb: Observable<[StyleConfigModel]> { get }
    var styleConfigValue: [StyleConfigModel] { get }
    
    var exampleConfigOsb: Observable<[ExampleRetouchModel]> { get }
    var exampleConfigValue: [ExampleRetouchModel] { get }
    
    var roomConfigOsb: Observable<[RoomTypeModel]> { get }
    var roomConfigValue: [RoomTypeModel] { get }
    
    var brushSizeConfigOsb: Observable<Int> { get }
    var brushSizeConfigValue: Int { get }
    
    // MARK: Monetization
    // Onboarding config
    var obConfigOsb: Observable<String> { get }
    var obConfigValue: String { get }
    
    // ds config
    var dsConfigOsb: Observable<DirectStoreConfigModel> { get }
    var dsConfigValue: DirectStoreConfigModel{ get }
    
    // Ads config
    var adsConfigOsb: Observable<AdsConfigModel> { get }
    var adsConfigValue: AdsConfigModel { get }
    
    var freeUsageConfigOsb: Observable<Int> { get }
    var freeUsageConfigValue: Int { get }
    
    var createDailyUsageLimitConfigOsb: Observable<Int> { get }
    var createDailyUsageLimitConfigValue: Int { get }
    
    var editDailyUsageLimitConfigOsb: Observable<Int> { get }
    var editDailyUsageLimitConfigValue: Int { get }
    
    // MARK: Another
    // Did get all value
    var didGetConfigOsb: Observable<Bool> { get }
    var didGetConfigValue: Bool { get }
}

final class RemoteConfigManagerImpl {
    
    static let shared: RemoteConfigManagerImpl = .init()
    let userDefault = UserDefaultService.shared
    
    let remoteConfig: RemoteConfig = {
        let rc = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        rc.configSettings = settings
        return rc
    }()
    
    // MARK: API Endpoints
    // api endpoint
    private let apiEndpointPublisher: BehaviorRelay<APIEndPointModel> = {
        .init(value: APIEndPointModel(flux: "", edit: ""))
    }()
    
    // api key
    private let apiKeyPublisher: BehaviorRelay<String> = {
        .init(value: "")
    }()
    
    // is using local key
    private let isUsingLocalKeyPublisher: BehaviorRelay<Bool> = {
        .init(value: false)
    }()
    
    
    private let fluxModelConfigPublisher: BehaviorRelay<FluxConfigModel> = {
        .init(value: FluxConfigModel(input: FluxModel(steps: 0, prompt: "", guidance: 0, control_image: "", output_format: "", safety_tolerance: 0, prompt_upsampling: false)))
    }()
    
    private let fluxFillDevModelConfigPublisher: BehaviorRelay<FluxFillDevConfigModel> = {
        .init(value: FluxFillDevConfigModel(input: FluxFillDevModel(mask: "", image: "", steps: 0, prompt: "", guidance: 0, outpaint: "", output_format: "", safety_tolerance: 0, prompt_upsampling: false)))
    }()
    
    // MARK: Configs
    // Rating config
    private let ratingPublisher: BehaviorRelay<RatingPopupRCModel> = {
        .init(value: RatingPopupRCModel(home: RatingHomeModel(enable: false), call_api: CallAPIModel(enable: false, count: 0)))
    }()
    
    // ratio
    private let ratioConfigPublisher: BehaviorRelay<[RatioConfigModel]> = {
        .init(value: [])
    }()
    
    // styles
    private let styleConfigPublisher: BehaviorRelay<[StyleConfigModel]> = {
        .init(value: [])
    }()
    
    // example retouch
    private let exampleRetouchConfigPublisher: BehaviorRelay<[ExampleRetouchModel]> = {
        .init(value: [])
    }()
    
    private let roomConfigPublisher: BehaviorRelay<[RoomTypeModel]> = {
        .init(value: [])
    }()
    
    private let brushSizeConfigPublisher: BehaviorRelay<Int> = {
        .init(value: 0)
    }()
    
    // Limit
    private let limitConfigPublisher: BehaviorRelay<LimitConfigModel> = {
        .init(value: LimitConfigModel(input_idea: 0))
    }()
    
    // MARK: Monetization
    // Ob
    private let obConfigPublisher: BehaviorRelay<String> = {
        .init(value: "")
    }()
    
   // ds
    private let dsConfigPublisher: BehaviorRelay<DirectStoreConfigModel> = {
        .init(value: DirectStoreConfigModel(type: "", close_button_delay: 0))
    }()
    
    // Ads
    private let adsConfigPublisher: BehaviorRelay<AdsConfigModel> = {
        .init(value: AdsConfigModel(interstital: InterstitalAdModel(enable: false, time: 0), banner: BannerAdModel(enable: false), rewarded: RewardedAdModel(enable: false, maxCreation: 0), appOpen: AppOpenAdModel(countShowDS: 0)))
    }()
    
    private let freeUsageConfigPublisher: BehaviorRelay<Int> = {
        .init(value: 0)
    }()
    
    private let createDailyUsageLimitConfigPublisher: BehaviorRelay<Int> = {
        .init(value: 0)
    }()
    
    private let editDailyUsageLimitConfigPublisher: BehaviorRelay<Int> = {
        .init(value: 0)
    }()
    
    // Usage
    private let usageConfigPublisher: BehaviorRelay<UsageConfigModel> = {
        .init(value: UsageConfigModel(freeUsage: 0, dailyUsage: 0))
    }()
    
    // MARK: Another
    private let didGetConfigPublisher: BehaviorRelay<Bool> = {
        .init(value: false)
    }()
    
    init() {
        guard !isConnectedToProxy() else { return }
        fetchRC()
        loadDataApp()
        
        guard !userDefault.isFirstLaunch else { return }
        realtimeRC()
    }
    
    func isConnectedToProxy() -> Bool {
        let host = "http://www.example.com"
        if let url = URL(string: host),
            let proxySettingsUnmanaged = CFNetworkCopySystemProxySettings() {
            let proxySettings = proxySettingsUnmanaged.takeRetainedValue()
            let proxyUnmanaged = CFNetworkCopyProxiesForURL(url as CFURL, proxySettings)
            if let proxies = proxyUnmanaged.takeRetainedValue() as? [[String : AnyObject]], proxies.count > 0 {
                let proxy = proxies[0]
                let key = kCFProxyTypeKey as String
                let value = kCFProxyTypeNone as String
                if let v = proxy[key] as? String, v != value {
                    return true
                }
            }
        }
        return false
    }
     
    func fetchRC() {
        let expirationDuration: TimeInterval
        #if DEBUG
        expirationDuration = 0
        #else
        expirationDuration = 30 * 60
        #endif
        
        remoteConfig.fetch(withExpirationDuration: expirationDuration) { (status, error) in
            guard error == nil else { return }
            self.remoteConfig.activate() { changed, error in
                guard error == nil else { return }
                print("RC FETCH")
                self.getDataRC()
            }
        }
    }
    
    func realtimeRC() {
        remoteConfig.addOnConfigUpdateListener { configUpdate, error in
            guard error == nil else { return }
            self.remoteConfig.activate { changed, error in
                guard error == nil else { return }
                DispatchQueue.main.async {
                    print("RC REALTIME")
                    self.getDataRC()
                }
            }
        }
    }
    
    func loadDataApp() {

    }
    
    func getDataRC() {
        do {
            // MARK: API Configs
            // Api key
            
            // api endpoint
            let apiEndpointRemote = self.remoteConfig.configValue(forKey: "api_endpoint").dataValue
            let apiEndpointData = try JSONDecoder().decode(APIEndPointModel.self, from: apiEndpointRemote)
            self.apiEndpointPublisher.accept(apiEndpointData)
            print("RC API Endpoints 1: \(apiEndpointData)")
            
            // api key
            let apiKeyRemote = self.remoteConfig.configValue(forKey: "api_key").stringValue
            self.apiKeyPublisher.accept(apiKeyRemote)
            print("RC API Endpoints 2: \(String(describing: apiKeyRemote))")
            
            // is using local key
            let isUsingLocalKeyRemote = self.remoteConfig.configValue(forKey: "is_using_local_key").boolValue
            self.isUsingLocalKeyPublisher.accept(isUsingLocalKeyRemote)
            print("RC API Endpoints 3: \(isUsingLocalKeyRemote)")
            
            let fluxModelConfigRC = self.remoteConfig.configValue(forKey: "flux_model_configs").dataValue
            let fluxModelCOnfigData = try JSONDecoder().decode(FluxConfigModel.self, from: fluxModelConfigRC)
            self.fluxModelConfigPublisher.accept(fluxModelCOnfigData)
            print("RC API Endpoints 4: \(fluxModelCOnfigData)")
            
            let fluxFillDevModelConfigRC = self.remoteConfig.configValue(forKey: "edit_interior_model_config").dataValue
            let fluxFillDevModelCOnfigData = try JSONDecoder().decode(FluxFillDevConfigModel.self, from: fluxFillDevModelConfigRC)
            self.fluxFillDevModelConfigPublisher.accept(fluxFillDevModelCOnfigData)
            print("RC API Endpoints 5: \(fluxFillDevModelCOnfigData)")
            
            // MARK: Configs
            // ratio
            let ratioRemote = self.remoteConfig.configValue(forKey: "ratio_configs").dataValue
            let ratioData = try JSONDecoder().decode([RatioConfigModel].self, from: ratioRemote)
            self.ratioConfigPublisher.accept(ratioData)
            print("RC Configs 1: \(ratioData)")
            
            // style
            let styleRemote = self.remoteConfig.configValue(forKey: "styles").dataValue
            let styleData = try JSONDecoder().decode([StyleConfigModel].self, from: styleRemote)
            self.styleConfigPublisher.accept(styleData)
            print("RC Configs 2: \(styleData)")
            

            
            // room
            let roomRemote = self.remoteConfig.configValue(forKey: "room_type_configs").dataValue
            let roomData = try JSONDecoder().decode([RoomTypeModel].self, from: roomRemote)
            self.roomConfigPublisher.accept(roomData)
            print("RC Configs 3: \(roomData)")
            
            // Limit
            let limitRemote = self.remoteConfig.configValue(forKey: "limit_config").dataValue
            let limitData = try JSONDecoder().decode(LimitConfigModel.self, from: limitRemote)
            self.limitConfigPublisher.accept(limitData)
            print("RC Configs 4: \(limitData)")
            
            // Save load more remainning count
            let ratingRemote = self.remoteConfig.configValue(forKey: "rating_configs").dataValue
            let ratingData = try JSONDecoder().decode(RatingPopupRCModel.self, from: ratingRemote)
            self.ratingPublisher.accept(ratingData)
            print("RC Configs 5: \(ratingData)")
            
            // example retouch
            let exampleRetouchRemote = self.remoteConfig.configValue(forKey: "example_retouch_configs").dataValue
            let exampleRetouchData = try JSONDecoder().decode([ExampleRetouchModel].self, from: exampleRetouchRemote)
            self.exampleRetouchConfigPublisher.accept(exampleRetouchData)
            print("RC Configs 6: \(exampleRetouchData)")
            
            // MARK: Monetization
            // Onboarding
            let onboardingRC = self.remoteConfig.configValue(forKey: "onboarding").stringValue
            self.obConfigPublisher.accept(onboardingRC)
            print("RC MONETIZATION 1: \(String(describing: onboardingRC))")
            
            // Directstore
            let dsRemote = self.remoteConfig.configValue(forKey: "directstore_configs").dataValue
            let dsData = try JSONDecoder().decode(DirectStoreConfigModel.self, from: dsRemote)
            self.userDefault.dsConfig = dsData
            print("RC MONETIZATION 2: \(dsData)")
            
            // Ads
            let adsRemote = self.remoteConfig.configValue(forKey: "ads_configs").dataValue
            let adsData = try JSONDecoder().decode(AdsConfigModel.self, from: adsRemote)
            
            self.adsConfigPublisher.accept(adsData)
            if self.userDefault.adsConfig.countShowDS.didSet == false {
                self.userDefault.adsConfig.countShowDS.didSet = true
                self.userDefault.adsConfig.countShowDS.count = adsData.appOpen.countShowDS
                self.userDefault.adsConfig.maxCreation = adsData.rewarded.maxCreation
            }
            
            print("RC MONETIZATION 3: \(adsData)")
            
//            let freeUsageRC = self.remoteConfig.configValue(forKey: "free_usage").numberValue
           
//            print("RC MONETIZATION 4: \(String(describing: freeUsageRC))")
            
//            let dailyUsageRC = self.remoteConfig.configValue(forKey: "daily_usage_limit").numberValue
//            self.createDailyUsageLimitConfigPublisher.accept(Int(truncating: dailyUsageRC))
//            print("RC MONETIZATION 5: \(String(describing: dailyUsageRC))")
            
            // Usage
            let dailyUsageLimit = self.remoteConfig.configValue(forKey: "limit_usage").dataValue
            let dailyUsageLimitData = try JSONDecoder().decode(DailyUsageLimitModel.self, from: dailyUsageLimit)
            self.createDailyUsageLimitConfigPublisher.accept(Int(truncating: dailyUsageLimitData.daily_limit.create as NSNumber))
            self.editDailyUsageLimitConfigPublisher.accept(Int(truncating: dailyUsageLimitData.daily_limit.edit as NSNumber))
            self.freeUsageConfigPublisher.accept(Int(truncating: dailyUsageLimitData.free_usage.create as NSNumber))
            print("RC MONETIZATION 4: \(dailyUsageLimitData)")


            // MARK: Another
            // Did get all value
            self.didGetConfigPublisher.accept(true)
            Developer.didGetRC = true
            print("RC LOAD DONE!!!")
            
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}

extension RemoteConfigManagerImpl: RemoteConfigManager {
    
    // MARK: API Configs
    // API Endpoint
    var apiEndpointOsb: Observable<APIEndPointModel> {
        apiEndpointPublisher.asObservable()
    }
    
    var apiEndpointValue: APIEndPointModel {
        apiEndpointPublisher.value
    }
    
    // API Key
    var apiKeyOsb: Observable<String> {
        apiKeyPublisher.asObservable()
    }
    
    var apiKeyValue: String {
        apiKeyPublisher.value
    }
    
    // Is using local key
    var isUsingLocalKeyOsb: Observable<Bool> {
        isUsingLocalKeyPublisher.asObservable()
    }
    
    var isUsingLocalKeyValue: Bool {
        isUsingLocalKeyPublisher.value
    }
    
    // Flux model config
    var fluxModelConfigOsb: Observable<FluxConfigModel> {
        fluxModelConfigPublisher.asObservable()
    }
    
    var fluxModelConfigValue: FluxConfigModel {
        fluxModelConfigPublisher.value
    }
    
    // fluxFillDevMode model config
    var fluxFillDevModelConfigValue: FluxFillDevConfigModel {
        fluxFillDevModelConfigPublisher.value
    }
    
    var fluxFillDevModelConfigOsb: Observable<FluxFillDevConfigModel> {
        fluxFillDevModelConfigPublisher.asObservable()
    }
   
    // MARK: Configs
    // Limit
    var limitConfigOsb: RxSwift.Observable<LimitConfigModel> {
        limitConfigPublisher.asObservable()
    }
    
    var limitConfigValue: LimitConfigModel {
        limitConfigPublisher.value
    }
    
    // Rating
    var ratingConfig: Observable<RatingPopupRCModel> {
        ratingPublisher.asObservable()
    }
    
    var ratingConfigValue: RatingPopupRCModel {
        ratingPublisher.value
    }
    
    var ratioConfigOsb: Observable<[RatioConfigModel]> {
        ratioConfigPublisher.asObservable()
    }
    
    var ratioConfigValue: [RatioConfigModel] {
        ratioConfigPublisher.value
    }
    
    // Style
    var styleConfigOsb: Observable<[StyleConfigModel]> {
        styleConfigPublisher.asObservable()
    }
    
    var styleConfigValue: [StyleConfigModel] {
        styleConfigPublisher.value
    }
    
    //example retouch
    var exampleConfigOsb: RxSwift.Observable<[ExampleRetouchModel]> {
        exampleRetouchConfigPublisher.asObservable()

    }
    var exampleConfigValue: [ExampleRetouchModel] {
        exampleRetouchConfigPublisher.value

    }
    
    var brushSizeConfigOsb: RxSwift.Observable<Int> {
        brushSizeConfigPublisher.asObservable()

    }
    
    var brushSizeConfigValue: Int {
        brushSizeConfigPublisher.value
    }
    
    // Room
    var roomConfigOsb: Observable<[RoomTypeModel]> {
        roomConfigPublisher.asObservable()
    }
    
    var roomConfigValue: [RoomTypeModel] {
        roomConfigPublisher.value
    }
    
    // MARK: Monetization
    // Ob
    var obConfigOsb: Observable<String> {
        obConfigPublisher.asObservable()
    }
    
    var obConfigValue: String {
        obConfigPublisher.value
    }
    
    // Ads
    var adsConfigOsb: Observable<AdsConfigModel> {
        adsConfigPublisher.asObservable()
    }
    
    var adsConfigValue: AdsConfigModel {
        adsConfigPublisher.value
    }
    
    // Ds
    var dsConfigOsb: Observable<DirectStoreConfigModel> {
        dsConfigPublisher.asObservable()
    }
    
    var dsConfigValue: DirectStoreConfigModel {
        dsConfigPublisher.value
    }
    
    // Free usage
    var freeUsageConfigOsb: Observable<Int> {
        freeUsageConfigPublisher.asObservable()
    }
    
    var freeUsageConfigValue: Int {
        freeUsageConfigPublisher.value
    }
    
    // Daily usage
    var createDailyUsageLimitConfigOsb: Observable<Int> {
        createDailyUsageLimitConfigPublisher.asObservable()
    }
    
    var createDailyUsageLimitConfigValue: Int {
        createDailyUsageLimitConfigPublisher.value
    }
    
    var editDailyUsageLimitConfigOsb: Observable<Int> {
        editDailyUsageLimitConfigPublisher.asObservable()
    }
    
    var editDailyUsageLimitConfigValue: Int {
        editDailyUsageLimitConfigPublisher.value
    }
    
    
    // MARK: Another
    // Did get
    var didGetConfigOsb: Observable<Bool> {
        didGetConfigPublisher.asObservable()
    }
    
    var didGetConfigValue: Bool {
        didGetConfigPublisher.value
    }
}
