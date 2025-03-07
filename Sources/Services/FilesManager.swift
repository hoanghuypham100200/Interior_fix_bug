import Foundation
import RxSwift

class FilesManager {
    static let shared: FilesManager = .init()

    func getDirectoryPath() -> NSURL {
        // path is main document directory path
        let documentDirectoryPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString)
        let pathWithFolderName = documentDirectoryPath.appendingPathComponent(Developer.folderHistoryArtwork)
        let url = NSURL(string: pathWithFolderName) // convert path in url

        return url!
    }

    func getImageFromDocumentDirectory(id: String) -> UIImage {
        let fileManager = FileManager.default
        // get image by name
        let imagePath = (self.getDirectoryPath() as NSURL).appendingPathComponent(id)
        let urlString: String = imagePath!.absoluteString
        var image = UIImage()
        if fileManager.fileExists(atPath: urlString) {
            image = UIImage(contentsOfFile: urlString)!
            return image
        } else {
            print("No Image Found")
        }
        return image
    }

    func loadImagesFromAlbum(folderName:String) -> [String] {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)

        print("path: \(paths)")
        var theItems = [String]()
        if let dirPath          = paths.first
        {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(folderName)

            do {
                theItems = try FileManager.default.contentsOfDirectory(atPath: imageURL.path)
                return theItems
            } catch let error as NSError {
                print(error.localizedDescription)
                return theItems
            }
        }

        return theItems
    }

    func saveImageDocumentDirectory(artWork: UIImage, idImage: String) {
        let fileManager = FileManager.default
        let url = (self.getDirectoryPath() as NSURL)
        
        // save image with name
        let imagePath = url.appendingPathComponent("\(idImage)")
        let urlString: String = imagePath!.absoluteString
        
        DispatchQueue.global().async { [weak self] in
            guard let wSelf = self else { return }
            
            let ImgForSave = artWork
            let imageData = UIImage.pngData(ImgForSave)
            
            do {
                try fileManager.removeItem(at: imagePath!)
            } catch let error {
                print("errorrrrrrr: \(error.localizedDescription)")
            }
            
            fileManager.createFile(atPath: urlString as String, contents: imageData(), attributes: nil)
        }
    }

    func deleteDirectory(fileName: String) {
        let fileManager = FileManager.default
        let yourProjectImagesPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(Developer.folderHistoryArtwork)/\(fileName)")
        if fileManager.fileExists(atPath: yourProjectImagesPath) {
            try! fileManager.removeItem(atPath: yourProjectImagesPath)
        }
    }
}
