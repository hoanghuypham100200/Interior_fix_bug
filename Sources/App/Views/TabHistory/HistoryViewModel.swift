import Foundation
import NVActivityIndicatorView
import UIKit
import RxSwift

class HistoryViewModel: BaseViewModel {
    static let shared = HistoryViewModel.init()
    
    private var modelManager: ModelManager {
        ModelManagerImpl.shared
    }
    
    private var remoteConfigManager: RemoteConfigManager {
        RemoteConfigManagerImpl.shared
    }
    
    var artWorks: Observable<[ArtworkModel]> {
        modelManager.artWorks
    }
    
    var artWorksValue: [ArtworkModel] {
        modelManager.artWorksValue
    }
    
}

extension HistoryViewModel {
    func updateArtWork(artWorkModel: ArtworkModel, artworkImage: UIImage) {
        modelManager.updateArtWork(artWorkModel: artWorkModel, artworkImage: artworkImage)
    }
    
    func deleteArtWork(artWorkModel: ArtworkModel) {
        modelManager.deleteArtWork(artWorkModel: artWorkModel)
    }
}
