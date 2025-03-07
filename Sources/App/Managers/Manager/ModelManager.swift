import Foundation
import UIKit
import RxCocoa
import RxSwift
import Firebase

protocol ModelManager {
    
    // save artwork when user create or dalle success
    var artWorks: Observable<[ArtworkModel]> { get }
    var artWorksValue: [ArtworkModel] { get }
    
    // show rw popup logo
    var showRwPopupCreateOsb: Observable<Bool> { get }
    var showRwPopupCreateValue: Bool { get }
    
    // start gen when rw dismiss logo
    var genWhenRwDismissCreateOsb: Observable<Bool> { get }
    var genWhenRwDismissCreateValue: Bool { get }
    
    // show rw popup logo
    var showProccessingViewOsb: Observable<Bool> { get }
    var showProccessingViewValue: Bool { get }
    
    var cancelGenOsb: Observable<Bool> { get }
    var cancelGenValue: Bool { get }
    
    // Usage
    var usageLeftOsb: Observable<Int> { get }
    var usageLeftValue: Int { get }
    
    // update show rw popup
    func updateShowRwPopupCreate(isShow: Bool)
    
    // update start gen when rw dismiss
    func updateGenWhenRwCreateDismiss(isGen: Bool)
    
    // update Proccessing View
    func updateShowProccessingView(isShow: Bool)
    func updateCancelGenView(cancel: Bool)
    
    func updateUsageLeft()
    func resetUsage()
    
    // update date history artwork
    func updateArtWork(artWorkModel: ArtworkModel, artworkImage: UIImage)
    func deleteArtWork(artWorkModel: ArtworkModel)
  
}

final class ModelManagerImpl {
    static let shared: ModelManagerImpl = .init()
    let userDefault = UserDefaultService.shared
    let filesManager = FilesManager.shared

    init() {
        // Update usage left
        loadGalleryArtwork()
        updateUsageLeft()
        
    }
    
    // danh sách ảnh
    private let artWorksPublisher: BehaviorRelay<[ArtworkModel]> = {
        .init(value: [])
    }()
    
    // Usage left
    private let usageLeftPublisher: BehaviorRelay<Int> = {
        .init(value: 0)
    }()
    
    // show rw popup logo
    private let showRwPopupCreatePublisher: BehaviorRelay<Bool> = {
        .init(value: false)
    }()
    
    // rw dismiss stiker
    private let genWhenRwDismissCreatePublisher: BehaviorRelay<Bool> = {
        .init(value: false)
    }()
    
    private let showProccessingViewPublisher: BehaviorRelay<Bool> = {
        .init(value: false)
    }()
    
    private let cancelGenPublisher: BehaviorRelay<Bool> = {
        .init(value: false)
    }()
    
    func loadGalleryArtwork() {
        artWorksPublisher.accept(userDefault.galleryPrompts)
    }
    
}

extension ModelManagerImpl: ModelManager {
    var artWorks: Observable<[ArtworkModel]> {
        artWorksPublisher.asObservable()
    }
    
    var artWorksValue: [ArtworkModel] {
        artWorksPublisher.value
    }
    
    // Usage left
    var usageLeftOsb: Observable<Int> {
        usageLeftPublisher.asObservable()
    }
    
    var usageLeftValue: Int {
        usageLeftPublisher.value
    }
    
    // show rw popup
    var showRwPopupCreateOsb: Observable<Bool> {
        showRwPopupCreatePublisher.asObservable()
    }
    
    var showRwPopupCreateValue: Bool {
        showRwPopupCreatePublisher.value
    }
    
    // start gen when rw dismiss
    var genWhenRwDismissCreateOsb: Observable<Bool> {
        genWhenRwDismissCreatePublisher.asObservable()
    }
    
    var genWhenRwDismissCreateValue: Bool {
        genWhenRwDismissCreatePublisher.value
    }
    
    var showProccessingViewOsb: Observable<Bool> {
        showProccessingViewPublisher.asObservable()
    }
    
    var showProccessingViewValue: Bool {
        showProccessingViewPublisher.value
    }
    
    var cancelGenOsb: Observable<Bool> {
        cancelGenPublisher.asObservable()
    }
    
    var cancelGenValue: Bool {
        cancelGenPublisher.value
    }
    
    func updateCancelGenView(cancel: Bool) {
        cancelGenPublisher.accept(cancel)
    }
    
    // update show rw popup
    func updateShowRwPopupCreate(isShow: Bool) {
        showRwPopupCreatePublisher.accept(isShow)
    }
    
    // update start gen when rw dismiss
    func updateGenWhenRwCreateDismiss(isGen: Bool) {
        genWhenRwDismissCreatePublisher.accept(isGen)
    }
    
    func updateShowProccessingView(isShow: Bool) {
        showProccessingViewPublisher.accept(isShow)
    }
    
    func updateArtWork(artWorkModel: ArtworkModel, artworkImage: UIImage) {
        var galleryArtworks = userDefault.galleryPrompts
        
        // update list history prompt
        
        galleryArtworks.append(artWorkModel)
        galleryArtworks.sort() { $0.id > $1.id }
        
        filesManager.saveImageDocumentDirectory(artWork: artworkImage, idImage: artWorkModel.id)
        userDefault.galleryPrompts = galleryArtworks
        artWorksPublisher.accept(galleryArtworks)
    }
    
    func deleteArtWork(artWorkModel: ArtworkModel) {
        var galleryArtworks = userDefault.galleryPrompts
        
        if let index = galleryArtworks.firstIndex(where: { $0.id == artWorkModel.id }) {
            galleryArtworks.remove(at: index)
            filesManager.deleteDirectory(fileName: artWorkModel.id)
            userDefault.galleryPrompts = galleryArtworks
            artWorksPublisher.accept(galleryArtworks)
        }
    }
  
}

extension ModelManagerImpl {
    
    // Usage
    func updateUsageLeft() {
        let remoteConfigManagerImpl = RemoteConfigManagerImpl.shared
        let userDefault = UserDefaultService.shared
        let dailyLimit = remoteConfigManagerImpl.dailyUsageLimitConfigValue    // Usage của user đã purchase
        let freeUsage = remoteConfigManagerImpl.freeUsageConfigValue    // Usage của user chưa purchase
        let usage = userDefault.usage // Số usage user đã sử dụng - User default
        let isPurchase = userDefault.isPurchase
        let usageLeft = calculateUsageLeft(limit: isPurchase ? dailyLimit : freeUsage, used: isPurchase ? usage.usagePremiumCount : usage.usageFreeCount)
        print("USAGE LEFT: \(usageLeft)")
        usageLeftPublisher.accept(usageLeft)
    }

    private func calculateUsageLeft(limit: Int, used: Int) -> Int {
        let usageLeft = limit - used
        return max(0, usageLeft) // Ensures that the usage left is not less than 0
    }
    
    // reset usage
    func resetUsage() {
        let userDefault = UserDefaultService.shared
        if userDefault.isPurchase {
           userDefault.usage.usagePremiumCount = 0
        } else {
           userDefault.usage.usageFreeCount = 0
        }
        updateUsageLeft()
    }
}
