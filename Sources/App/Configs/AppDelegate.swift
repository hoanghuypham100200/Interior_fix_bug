import Foundation
import RxSwift
import AVFAudio
import UIKit
import Firebase
import Qonversion
import GoogleMobileAds
import Hero
import AppTrackingTransparency

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    lazy var deeplinkCoordinator: DeeplinkCoordinatorProtocol = {
        return DeeplinkCoordinator(handlers: [
            BlogsDeeplinkHandler(rootViewController: self.rootViewController)
        ])
    }()
    
    var rootViewController: UIViewController? {
        return window?.rootViewController
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        return deeplinkCoordinator.handleURL(url)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        sleep(1)
        
        // MARK: Firebase
        FirebaseApp.configure()
        
        //MARK: Google ads
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
    
        // MARK: IAP
        setupIAP()
        
        // MARK: Initialize views
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        // MARK: First launch settings
        let userDefault = UserDefaultService.shared
        
        // MARK: Event first open
        if userDefault.isFirstOpen {
            userDefault.isFirstOpen = false
            AnalyticService.logEvent(.tl_first_open)
        }
        
        // check create folder for save image
        if userDefault.isCreateFolderImage == false {
            createFolderForSavePrompt()
            userDefault.isCreateFolderImage = true
        }
        

        #if DEBUG
//        userDefault.isPurchase = true
        #endif
        
        // MARK: Navigation
        let nav = UINavigationController(rootViewController: RootViewController())
        nav.setNavigationBarHidden(true, animated: false)
        nav.hero.isEnabled = true
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        
        // MARK: Prevent app's screen lock
        UIApplication.shared.isIdleTimerDisabled = true
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // MARK: ATT permission
        setupATT()
        print("APP DID BECOME ACTIVE")
        
        // MARK: App open ad
        setupOpenAd(application)
        
        // MARK: Check permission
        #if DEBUG
        #else
        let iapManager = IAPManager.shared
        iapManager.checkPermissions { success in
            print("---- qonversion: Check permission \(success)")
        }
        #endif
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        UserDefaultService.shared.isEnterBackground = true
    }
    
    private func setupIAP() {
        // Qonversion
        let iapManager = IAPManager.shared
        iapManager.configure { success in
            if success {
                #if DEBUG
                #else
                print("---- qonversion: Config success")
                iapManager.checkPermissions { success in
                    print("---- qonversion: Check permission \(success)")
                }
                #endif
            } else {
                print("---- qonversion: Config failed")
            }
        }
    }
    
    private func setupATT() {
        // request ATT permission
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    print("enable tracking")
                case .denied:
                    print("disable tracking")
                default:
                    print("disable tracking")
                }
            }
        }
    }
    
    private func setupOpenAd(_ application: UIApplication) {
        let disposeBag = DisposeBag()
        let userDefault = UserDefaultService.shared
        
        // Check đã xuống bg chưa (tránh khi vào launch bị check là didbecome)
        guard !userDefault.isPurchase, userDefault.isEnterBackground, Developer.didGetRC, !userDefault.isFirstLaunch else { return }
        userDefault.isEnterBackground = false
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        let rootViewController = window?.rootViewController
        
        if let rootViewController = rootViewController {
            if rootViewController is SplashViewController {
                return
            }
            // Show open ad
            AppOpenAdService.shared.showAd()
                .withUnretained(self)
                .observe(on: scheduler.main)
                .subscribe(onNext: { owner, isShow in
                    
                    guard !isShow else { return }
                    // Update count show ds
                    if userDefault.adsConfig.countShowDS.count > 0 {
                        userDefault.adsConfig.countShowDS.count -= 1
                    }
                    let dsVC = AppRouter.makeDirectStoreMain(value: Value.open.rawValue)
                    rootViewController.present(dsVC, animated: true)
                })
                .disposed(by: disposeBag)
        }
    }
    
    private func createFolderForSavePrompt() {
        let fileManager = FileManager.default
        let pathWithFolderName = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(Developer.folderHistoryArtwork)
        
        print("Document Directory Folder Path :- ",pathWithFolderName)
        
        if !fileManager.fileExists(atPath: pathWithFolderName) {
            try! fileManager.createDirectory(atPath: pathWithFolderName, withIntermediateDirectories: true, attributes: nil)
        }
    }
}
