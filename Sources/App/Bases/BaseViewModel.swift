import Foundation
import NVActivityIndicatorView
import RxSwift
import RxCocoa

class BaseViewModel: RxObject {
    
    // MARK: Public
    var purchaseObservable: Observable<PurchaseModel> {
        purchaseManager.purchaseObservable
            .withUnretained(self)
            .map { owner, purchase in
                owner.purchaseModel = purchase
                return purchase
            }
    }
    
    var isPurchase: Bool {
        purchaseModel.isPurchase
    }
    
    // MARK: Private
    private var purchaseModel: PurchaseModel = .init(isPurchase: false )
    
    private var purchaseManager: PurchaseManager {
        PurchaseManagerImpl.shared
    }
    
    private var modelManager: ModelManager {
        ModelManagerImpl.shared
    }
    
    private var remoteConfigManager: RemoteConfigManager {
        RemoteConfigManagerImpl.shared
    }
}

extension BaseViewModel {
    
    // rating
    var ratingConfig: Observable<RatingPopupRCModel> {
        remoteConfigManager.ratingConfig
    }
    
    var ratingConfigValue: RatingPopupRCModel {
        remoteConfigManager.ratingConfigValue
    }
    
    func addWatermark(to image: UIImage) -> UIImage? {
        // Define the scale factor to 1.0 to keep the image size consistent
        let rendererFormat = UIGraphicsImageRendererFormat()
        rendererFormat.scale = 1.0
        
        let renderer = UIGraphicsImageRenderer(size: image.size, format: rendererFormat)
        let textPadding = image.size.height * 0.04
        let watermarkHeight = image.size.height * 0.28
        
        return renderer.image { context in
            // Draw the original image as background
            image.draw(at: CGPoint.zero)
            
            // Create gradient layer
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [
                UIColor.black.withAlphaComponent(0).cgColor,
                UIColor.black.withAlphaComponent(0.39).cgColor,
                UIColor.black.withAlphaComponent(0.8).cgColor
            ]
            gradientLayer.locations = [0.0, 0.4, 1.0]
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
            gradientLayer.frame = CGRect(x: 0, y: image.size.height - watermarkHeight, width: image.size.width, height: watermarkHeight)
            
            // Render gradient layer to image
            let gradientImage = UIGraphicsImageRenderer(size: gradientLayer.frame.size, format: rendererFormat).image { gradientContext in
                gradientLayer.render(in: gradientContext.cgContext)
            }
            
            // Draw the gradient image on top of the original image
            gradientImage.draw(at: CGPoint(x: 0, y: image.size.height - watermarkHeight))
            
            // Define the attributes of the watermark text
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: textPadding, weight: .bold),
                .foregroundColor: UIColor.white  // Changed from AppColor.text to UIColor.white for this example
            ]
            
            // Calculate the position to draw the watermark text
            let text = NSString(string: "AI Headshot")
            let textSize = text.size(withAttributes: attributes)
            let textRect = CGRect(x: textPadding, y: image.size.height - textSize.height - textPadding, width: textSize.width, height: textSize.height)
            
            // Draw the watermark text
            text.draw(in: textRect, withAttributes: attributes)
        }
    }
    
    // MARK: POPUP
    // proxy
    func popupProxy(viewController: UIViewController) {
        let alert = UIAlertController(title: "Error", message: "Turn off proxy settings to use this app", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.exitApp()
        }))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    // Enough usage
    func popupUsageEnough(viewController: UIViewController, messageError: String = "Something went wrong, please try later!") {
        let alert = UIAlertController(title: "Notification", message: messageError, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    // MARK: PROXY
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
    
    func exitApp() {
        UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
    }
    
    func resetUsage() {
        modelManager.resetUsage()
    }
    
    func updateDailyTime(completion: @escaping(Bool) -> Void) {
        let userDefault = UserDefaultService.shared
        
        guard userDefault.isPurchase else {
            completion(true)
            return
        }
        
        TrueTimeService.shared.fetchCurrentTime { [weak self] result in
            guard let owner = self else {
                completion(false)
                return
            }
            DispatchQueue.main.async {
                switch result {
                case .success(let time):
                    let timeUser = userDefault.usage.usagePremiumLastTime

                    print("LOG TIME LEFT: \(time - timeUser)")
                    
                    // Khi init app, set first time
                    if timeUser == 0 {
                        userDefault.usage.usagePremiumLastTime = time
                    }
                    
                    // Qua ngày mới, set lại time và count
                    if time - userDefault.usage.usagePremiumLastTime > 86400 {
                        userDefault.usage.usagePremiumLastTime = time
                        owner.resetUsage()
                    }
                    
                    completion(true)
                    
                case .failure(let error):
                    print("LOG TIME: ERROR: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
    }
    
    func apiRequestTracking(isSuccess: Bool, nameRequest: Value ) {
        AnalyticService.logEventMain(event: Event.api_request.rawValue, listParameters: [
            Param.value.rawValue: isSuccess ? Value.success.rawValue : Value.fail.rawValue,
            Param.type.rawValue: nameRequest.rawValue
        ])
    }
}
