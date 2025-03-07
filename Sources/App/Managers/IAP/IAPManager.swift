import Foundation
import RxSwift
import Qonversion

class IAPManager {
    static let shared = IAPManager()
    init() {}
    var listProducts = [IAPModel]()
    
    private var purchaseManager: PurchaseManager {
        PurchaseManagerImpl.shared
    }
    
    func configure(completion: @escaping (Bool) -> Void) {
        Qonversion.launch(withKey: Developer.qonversionKey) { result, error in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    func disPlayProduct(completion: @escaping (Bool) -> Void) {
        guard listProducts.isEmpty else {
            completion(true)
            return
        }
        
        Qonversion.products { (products, error) in
            guard error == nil else {
                completion(false)
                return
            }
            
            let locale = Locale.current
            let currencySymbol = locale.currencySymbol ?? ""
            
            for element in products {
                let price = element.value.prettyPrice.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)
                self.listProducts.append(IAPModel(id: element.value.qonversionID, title: element.value.storeID, description: element.value.description, price: price, symbol: currencySymbol))
            }
            
            print("List product: \(self.listProducts)")
            
            completion(true)
        }
    }
    
    func checkPermissions(completion: @escaping (Bool) -> Void) {
        Qonversion.checkPermissions { [weak self] permissions, error in
            
            if permissions.isEmpty {
                completion(false)
            } else {
                if permissions.keys.contains("premium") {
                    self?.purchaseManager.updatePurchase(isPurchase: true)
                } else {
                    self?.purchaseManager.updatePurchase(isPurchase: false)
                }
                completion(true)
            }
        }
    }
    
    func purchase(product: String, completion: @escaping (Bool) -> Void) {
        Qonversion.purchase(product) { [weak self] result, error, cancelled in
            guard error == nil else {
                completion(false)
                print("===> error \(String(describing: error?.localizedDescription))")
                return
            }
            if cancelled {
                completion(false)
                print("===> cancelled")
            } else {
                self?.purchaseManager.updatePurchase(isPurchase: true)
                completion(true)
                print("===> purchased")
            }
        }
    }
    
    func restorePurchase(completion: @escaping (Bool) -> Void) {
        Qonversion.restore { [weak self] results, error in
            guard error == nil else {
                completion(false)
                print("---- restore \(String(describing: error?.localizedDescription))")
                return
            }
            if results.isEmpty {
                completion(false)
            } else {
                print("====> results \(results)")
                print("====> ")
                
                if results.keys.contains("premium") {
                    self?.purchaseManager.updatePurchase(isPurchase: true)
                } else {
                    self?.purchaseManager.updatePurchase(isPurchase: false)
                }
                completion(true)
            }
        }
    }
}

