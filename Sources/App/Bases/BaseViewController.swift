import Foundation
import StoreKit
import RxSwift
import RxCocoa
import UIKit
import SnapKit
import GoogleMobileAds
import Toast_Swift

protocol BaseViewControllerDelegate: AnyObject {
    func didTapMenuButton(isShowMenu: Bool)
}

class BaseViewController: UIViewController, GADBannerViewDelegate {
   
    deinit {
        print("========= Deinit", String(describing: self))
    }
    
    // Header
    public lazy var tabbarHeader = TabbarHeader()
    public lazy var screenHeader = ScreenHeader()
    public lazy var modalHeader = ModalHeader()
    
    public lazy var bgDeletePopupButton = UIButton()
    public lazy var deletePopupView = DeletePopupView()

    // Rating popup
    public lazy var ratingView = RatingView()
    public lazy var bgRaingView = UIButton()
    
    // Tap gesture button
    public lazy var tapGestureButton = UIButton()
    
    // Banner Ad
    var bannerView: GADBannerView!
    
    static var tapGestureRecognizer: UITapGestureRecognizer?

    weak var menuDelegate: BaseViewControllerDelegate?
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bg_1
        self.navigationController?.navigationBar.isHidden = true
        setupViews()
        setupRx()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        localize()
    }
    
    @objc dynamic func setupViews() {
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = AdMob.bannerAdId
        bannerView.rootViewController = self
        
        bannerView.delegate = self
    }
    
    @objc dynamic func setupRx() {
        checkProxyInBecomeActive()
    }
    
    @objc dynamic func localize() {
    }
    
    // MARK: Tabbar Header -
    func addTabbarHeader() {
        view.addSubview(tabbarHeader)
        tabbarHeader.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.snp_topMargin)
            $0.height.equalTo(52.scaleX)
        }
    }
    
    func configTapPremiumTabbarHeader() {
        tabbarHeader.premiumButton.rx.tap
            .throttle(.milliseconds(300), scheduler: scheduler.main)
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, _ in
                owner.openDailyLimitModal(value: Value.ad.rawValue)
            })
            .disposed(by: disposeBag)
    }
    
    // delete popup
    func addDeletePopupView () {
        bgDeletePopupButton.backgroundColor = AppColor.text_black.withAlphaComponent(0.9)
        bgDeletePopupButton.isHidden = true
        
        view.addSubview(bgDeletePopupButton)
        bgDeletePopupButton.addSubview(deletePopupView)
        
        bgDeletePopupButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        deletePopupView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(CGSize(width: 305.scaleX, height: 219.scaleX))
        }
    }
    
    func hideDeletePopup() {
        bgDeletePopupButton.isHidden = true
    }
    
    // Show rw ad popup
    func showDeletePopup() {
        bgDeletePopupButton.isHidden = false
        deletePopupView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 5.0,
                       options: .allowUserInteraction,
                       animations: {
            self.deletePopupView.alpha = 1
            self.deletePopupView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
    }
    
    func configTapDeletePopup() {
        bgDeletePopupButton.rx.tap
            .throttle(.milliseconds(300), scheduler: scheduler.main)
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, _ in
                owner.hideDeletePopup()
            })
            .disposed(by: disposeBag)
        
        deletePopupView.closeButton.rx.tap
            .throttle(.milliseconds(300), scheduler: scheduler.main)
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, _ in
                owner.hideDeletePopup()
            })
            .disposed(by: disposeBag)
        
        deletePopupView.noButton.rx.tap
            .throttle(.milliseconds(300), scheduler: scheduler.main)
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, _ in
                owner.hideDeletePopup()
            })
            .disposed(by: disposeBag)
    }
    
    
    // MARK: Screen Header -
    func addScreenHeader() {
        view.addSubview(screenHeader)
        screenHeader.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.snp_topMargin)
            $0.height.equalTo(50.scaleX)
        }
    }
    
    func actionBackScreenHeader() {
        screenHeader.backButton.rx.tap
            .throttle(.milliseconds(300), scheduler: scheduler.main)
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Modal Header -
    func addModalHeader() {
        view.addSubview(modalHeader)
        modalHeader.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(70.scaleX)
        }
    }
    
    // MARK: Banner AD -
    func addScreenBanner() {
        view.addSubview(bannerView)
        bannerView.backgroundColor = .white
        
        bannerView.snp.makeConstraints {
            $0.top.equalTo(screenHeader.snp.bottom)
            $0.width.equalToSuperview()
            $0.height.equalTo(50)
        }
    }
    
    func removeBanner() {
        bannerView.removeFromSuperview()
    }
    
    public func removeLastScreen(isDirectStore: Bool) {
        if isDirectStore {
            UserDefaultService.shared.isFirstLaunch = false
            self.navigationController?.pushViewController(TabBarViewController(), animated: true)
        }
        
        guard let navigationController = self.navigationController else { return }
        var navigationArray = navigationController.viewControllers // To get all UIViewController stack as Array
        guard let temp = navigationArray.last else { return }
        navigationArray.removeAll()
        navigationArray.append(temp) //To remove all previous UIViewController except the last one
        self.navigationController?.viewControllers = navigationArray
    }
    
    // MARK: Rating -
    func addRatingView() {
        bgRaingView.backgroundColor = AppColor.text_black.withAlphaComponent(0.85)
        bgRaingView.isHidden = true
        
        view.addSubview(bgRaingView)
        bgRaingView.addSubview(ratingView)
        
        bgRaingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        ratingView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(Developer.isHasNortch ? 337.scaleX : 270.scaleX)
        }
        
    }
    
    func showRating() {
        bgRaingView.isHidden = false
        ratingView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 5.0,
                       options: .allowUserInteraction,
                       animations: {
            self.ratingView.alpha = 1
            self.ratingView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
    }
    
    func hideRating(delay: Int = 0) {
        let dispatchAfter = DispatchTimeInterval.milliseconds(delay)
        DispatchQueue.main.asyncAfter(deadline: .now() + dispatchAfter) {
            self.bgRaingView.isHidden = true
        }
    }
    
    func ratingPopup() {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/" + Developer.itcAppID + "?action=write-review") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func configTapRating() {
        bgRaingView.rx.tap
            .throttle(.milliseconds(300), scheduler: scheduler.main)
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, _ in
                owner.hideRating()
            })
            .disposed(by: disposeBag)
        
        ratingView.nothanksButton.rx.tap
            .throttle(.milliseconds(300), scheduler: scheduler.main)
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, _ in
                owner.hideRating()
            })
            .disposed(by: disposeBag)
        
        ratingView.confirmButton.rx.tap
            .throttle(.milliseconds(300), scheduler: scheduler.main)
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, _ in
                owner.hideRating()
                owner.ratingPopup()
            })
            .disposed(by: disposeBag)
    }
    
    func openDsLimit(value: String) {
        let dsVC = AppRouter.makeDirectStoreMain(value: value)
        present(dsVC, animated: true)
    }
    
    func openDailyLimitModal (value: String) {
        let dailyLimit = DailyLimitModal()
        dailyLimit.updateDailyLimit(usage: UserDefaultService.shared.usage.usageFreeCount, free: RemoteConfigManagerImpl.shared.freeUsageConfigValue)
        dailyLimit.value = value
        dailyLimit.delegate = self
        presentPanModal(dailyLimit)
    }
  
    
    func ratingDefaultPopup() {
        guard let scene = self.view.window?.windowScene else { return }
        SKStoreReviewController.requestReview(in: scene)
    }
    
    // MARK: Popup -
    func showPopup(message: String, duration: Double) {
        view.makeToast(message, duration: duration, position: .center)
    }
    
    func popupAPIError(messageError: String = "Something went wrong. Please try again!", action: @escaping(() -> Void)) {
        let alert = UIAlertController(title: "Error", message: messageError, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { _ in
            action()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func popupUsageEnough(messageError: String = "You have reached the daily usage limit. Please come back tomorrow to continue using this feature.") {
        let alert = UIAlertController(title: "Notification", message: messageError, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func popupNoRwAds() {
        let alert = UIAlertController(title: "Notification", message: "We've run out of ads. Please try later or go premium to get unlimited use.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Later", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Go", style: .default, handler: { [weak self] action in
            guard let wSelf = self else { return }
            let dsVC = AppRouter.makeDirectStoreMain(value: Value.ad.rawValue)
            wSelf.present(dsVC, animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // popup limit canvas
    func popupLimit(featureName: String, limit: Int) {
        let alert = UIAlertController(title: "Notification",
                                      message: "'\(featureName)' is suitable for single words. Shorten your text to under \(limit) characters and try again.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // popup warning
    func popupWarning(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func popupWithAction(title: String = "Notification", message: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { [weak self] action in
            guard let _ = self else { return }
            completion()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func popupCancelGen(completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "Cancel processing", message: "Your book is summarizing, do you want to cancel it?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Sure", style: .default, handler: { [weak self] action in
            guard let _ = self else { return }
            completion()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Rating
    func openRatingApp(completion: @escaping(Bool) -> Void) {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/" + Developer.itcAppID + "?action=write-review") {
            UIApplication.shared.open(url, options: [:]) { result in
                completion(true)
            }
        } else {
            completion(false)
        }
    }
    
    // MARK: Popover -
    func configPopover(viewController: UIViewController, cgrect: CGRect) {
        let popover: UIPopoverPresentationController = viewController.popoverPresentationController!
        popover.delegate = self
        popover.sourceView = self.view
        popover.sourceRect = cgrect
        popover.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        popover.backgroundColor = AppColor.text_black
    }
    
    func popupError(messageError: String = "Something went wrong. Please try again!") {
        let alert = UIAlertController(title: "Error", message: messageError, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Proxy -
    func popupProxy(messageError: String = "Turn off proxy settings to use this app") {
        let alert = UIAlertController(title: "Error", message: messageError, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] action in
            guard let wSelf = self else { return }
            wSelf.exitApp()
        }))
        self.present(alert, animated: true, completion: nil)
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
    
    func checkProxyInBecomeActive() {
        NotificationCenter.default.rx
            .notification(UIApplication.didBecomeActiveNotification)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                guard owner.isConnectedToProxy() else { return }
                owner.popupProxy()
            })
            .disposed(by: disposeBag)
    }
    
    func exitApp() {
        UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
    }
    
    // MARK: Live text
    func isLiveTextSupported() -> Bool {
        var isSupported = true
        if #available(iOS 15.0, *) {
            let check = UITextView().canPerformAction(#selector(UIResponder.captureTextFromCamera(_:)), withSender: nil)
            isSupported = check
        } else {
            isSupported = false
        }
        
        return isSupported
    }
    
    // MARK: Anim expand - collapse view
    func animExpandCollapse() {
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: Copy text
    func copyText(content: String) {
        UIPasteboard.general.string = content
        view.makeToast("Copied", duration: 0.5, position: .center)
    }
    
    // MARK: Share text
    func shareText(content: String) {
        let textToShare = [ content ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: Open url web
    func openUrl(url: String) {
        guard let url = URL(string: url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    // MARK: Save - share action
    @objc func image(_ image: CIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let _ = error {
            showPopup(message: "Save error", duration: 1.0)
        } else {
            showPopup(message: "Your artwork has been saved to your photos.", duration: 1.0)
        }
    }
    
    func saveImage(imageResult: UIImage?) {
        guard let image = imageResult else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func shareImage(imageResult: UIImage?) {
        guard let image = imageResult else { return }
        let imageToShare = [ image ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare as [Any], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view
        present(activityViewController, animated: true, completion: nil)
    }
}

extension BaseViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension BaseViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}

// MARK: Ads
extension BaseViewController {
    func displayIntersitialAd() {
            InterstitialAdService.shared.showAd(on: self)
                .withUnretained(self)
                .observe(on: scheduler.main)
                .subscribe(onNext: { owner, value in
                    print("Interstitial result show ad: \(value)")
                })
                .disposed(by: self.disposeBag)
    }
}

extension BaseViewController: DailyLimitDelegate {
    func openDs(value: String) {
        openDsLimit(value: value)
    }
}
