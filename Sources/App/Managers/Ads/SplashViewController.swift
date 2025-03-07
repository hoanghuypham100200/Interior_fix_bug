import GoogleMobileAds
import UIKit

class SplashViewController: UIViewController, AppOpenAdServiceDelegate {
    
    /// Number of seconds remaining to show the app open ad.
    /// This simulates the time needed to load the app.
    var secondsRemaining: Int = 5
    /// The countdown timer.
    var countdownTimer: Timer?
    /// Indicates whether the Google Mobile Ads SDK has been intitialized.
    private var isMobileAdsStartCalled = false
    /// Text that indicates the number of seconds left to show an app open ad.
    @IBOutlet weak var splashScreenLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppOpenAdService.shared.appOpenAdServiceDelegate = self
        startTimer()
        
        GoogleMobileAdsConsentManager.shared.gatherConsent(from: self) {
            [weak self] consentError in
            guard let self else { return }
            
            if let consentError {
                // Consent gathering failed.
                print("Error: \(consentError.localizedDescription)")
            }
            
            if GoogleMobileAdsConsentManager.shared.canRequestAds {
                self.startGoogleMobileAdsSDK()
            }
            
            // Move onto the main screen if the app is done loading.
            if self.secondsRemaining <= 0 {
                self.startMainScreen()
            }
        }
        
        // This sample attempts to load ads using consent obtained in the previous session.
        if GoogleMobileAdsConsentManager.shared.canRequestAds {
            startGoogleMobileAdsSDK()
        }
    }
    
    @objc func decrementCounter() {
        secondsRemaining -= 1
        guard secondsRemaining <= 0 else {
            splashScreenLabel.text = "App is done loading in: \(secondsRemaining)"
            return
        }
        
        splashScreenLabel.text = "Done."
        countdownTimer?.invalidate()
        //    OpenAdService.shared.showAdIfAvailable()
    }
    
    private func startGoogleMobileAdsSDK() {
        DispatchQueue.main.async {
            guard !self.isMobileAdsStartCalled else { return }
            
            self.isMobileAdsStartCalled = true
            
            // Initialize the Google Mobile Ads SDK.
            GADMobileAds.sharedInstance().start()
            
            // Load an ad.
            Task {
                AppOpenAdService.shared.loadAd()
            }
        }
    }
    
    func startTimer() {
        splashScreenLabel.text = "App is done loading in: \(secondsRemaining)"
        countdownTimer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(SplashViewController.decrementCounter),
            userInfo: nil,
            repeats: true)
    }
    
    func startMainScreen() {
        AppOpenAdService.shared.appOpenAdServiceDelegate = nil
        let navigationController = TabBarViewController()
        present(navigationController, animated: true) {
            self.dismiss(animated: false) {
                // Find the keyWindow which is currently being displayed on the device,
                // and set its rootViewController to mainViewController.
                let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
                keyWindow?.rootViewController = navigationController
            }
        }
    }
    
    // MARK: AppOpenAdManagerDelegate
    func appOpenAdServiceAdDidComplete(_ appOpenAdService: AppOpenAdService) {
        startMainScreen()
    }
}
