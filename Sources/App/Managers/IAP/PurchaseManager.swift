import Foundation
import RxSwift
import RxCocoa

protocol PurchaseManager {
    var purchaseObservable: Observable<PurchaseModel> { get }
    
    func updatePurchase(isPurchase: Bool)
}

final class PurchaseManagerImpl {
    static let shared: PurchaseManagerImpl = .init()
    
    private let purchasePublisher: BehaviorRelay<PurchaseModel> = {
        .init(value: PurchaseModel(isPurchase: false))
    }()
}

extension PurchaseManagerImpl: PurchaseManager {
    
    var purchaseObservable: Observable<PurchaseModel> {
        purchasePublisher.asObservable()
    }
    
    func updatePurchase(isPurchase: Bool) {
        // Update purchase UD
        let userDefault = UserDefaultService.shared
        userDefault.isPurchase = isPurchase
        
        // Emit event for subscribers
        let purchase = PurchaseModel(isPurchase: isPurchase)
        purchasePublisher.accept(purchase)
        
        // Update daily usage when user purchase/restore
        let viewModel = CreateViewModel.shared
        if isPurchase && !userDefault.usage.isUpdatedDailyUsageWhenPurchase  {
            userDefault.usage.isUpdatedDailyUsageWhenPurchase = true
            viewModel.resetUsage()
        }
        
    }
}
