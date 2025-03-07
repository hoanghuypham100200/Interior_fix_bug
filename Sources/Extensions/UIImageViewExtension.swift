import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    
    func setIcon(icon: UIImage?) {
        self.image = icon
        self.contentMode = .scaleAspectFit
    }
    
    func setSymbol(name: String, color: UIColor, size: CGFloat, weight: UIImage.SymbolWeight) {
        let configWeight = UIImage.SymbolConfiguration(pointSize: size, weight: weight)
        let icon = UIImage(systemName: name, withConfiguration: configWeight)
        let configIcon = icon?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
        self.image = configIcon
        self.contentMode = .scaleAspectFit
    }
    
    func setImage(image: UIImage?, color: UIColor, alpha: CGFloat = 1.0) {
        let configImage = image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color.withAlphaComponent(alpha)
        self.image = configImage
        self.contentMode = .scaleAspectFit
    }
    
    func load(urlAddress: String, completion: @escaping (Bool) -> ()) {
        guard let url = URL(string: urlAddress) else {
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        completion(true)
                    }
                }
            }
        }
    }
    
    func loadImageKF(thumbURL: String, completion: @escaping (Bool) -> ()) {
        let url = URL(string: thumbURL)
        guard let url = url else { return }

        self.kf.setImage(with: url, options: [
            .progressiveJPEG(.init()),
            .callbackQueue(.mainAsync),
            .diskCacheExpiration(.never)]) { result in
            switch result {
            case .success(let value):
                print("\(value)")
                completion(true)
                
            case .failure(let error):
                print("\(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
    func setIconSystem(name: String, color : UIColor, weight: UIImage.SymbolWeight = .medium, sizeIcon: Int) {
        
        image = UIImage(systemName: name, withConfiguration: UIImage.SymbolConfiguration(pointSize: CGFloat(sizeIcon), weight: .medium))

        // Đảm bảo rằng hình ảnh có thể thay đổi màu sắc
        image = image?.withRenderingMode(.alwaysTemplate)

        // Đặt màu sắc bạn muốn sử dụng cho hình ảnh
        tintColor = color
    }
    
    func calculateWidth(for systemName: String, pointSize: CGFloat, weight: UIImage.SymbolWeight, targetHeight: CGFloat) -> CGFloat? {
        let config = UIImage.SymbolConfiguration(pointSize: pointSize, weight: weight)
        if let image = UIImage(systemName: systemName, withConfiguration: config) {
            let originalWidth = image.size.width
            let originalHeight = image.size.height
            let width = targetHeight * (originalWidth / originalHeight)
            return width
        }
        return nil
    }
    
}
