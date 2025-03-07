import Foundation
import UIKit

extension UIImage {
    
    func isEqualToImage(_ image: UIImage) -> Bool {
        let data1 = self.pngData()
        let data2 = image.pngData()
        return data1 == data2
    }
    
    func fixOrientation() -> UIImage? {
        UIGraphicsBeginImageContext(self.size)
        self.draw(at: .zero)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
    func toBase64() -> String? {
        guard let imageData = self.pngData() else { return nil }
        return imageData.base64EncodedString(options: .lineLength64Characters)
    }
    
    func setIconSystem(name: String, color: UIColor, weight: UIImage.SymbolWeight = .medium) -> UIImage {
           let configuration = UIImage.SymbolConfiguration(weight: weight)
           var image = UIImage(systemName: name, withConfiguration: configuration)
           
           // Đảm bảo rằng hình ảnh có thể thay đổi màu sắc
           image = image?.withRenderingMode(.alwaysTemplate)
           
           // Đặt màu sắc cho hình ảnh
           image = image?.withTintColor(color, renderingMode: .alwaysOriginal)
           
        return image ?? self
    }
    
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ? CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
            let size = image.size
            let widthRatio  = targetSize.width  / size.width
            let heightRatio = targetSize.height / size.height

            // Determine the scale factor to maintain the aspect ratio
            var newSize: CGSize
            if(widthRatio > heightRatio) {
                newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
            } else {
                newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
            }

            let rect = CGRect(origin: .zero, size: newSize)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            image.draw(in: rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return newImage!
        }

        // Function to crop the image to a specific aspect ratio
        func cropImageToRatio(image: UIImage, aspectRatio: CGFloat) -> UIImage {
            let originalWidth = image.size.width
            let originalHeight = image.size.height
            
            let originalAspectRatio = originalWidth / originalHeight
            
            var cropRect: CGRect
            
            if originalAspectRatio > aspectRatio {
                // Image is wider than the target ratio, crop width
                let newWidth = originalHeight * aspectRatio
                cropRect = CGRect(x: (originalWidth - newWidth) / 2, y: 0, width: newWidth, height: originalHeight)
            } else {
                // Image is taller than the target ratio, crop height
                let newHeight = originalWidth / aspectRatio
                cropRect = CGRect(x: 0, y: (originalHeight - newHeight) / 2, width: originalWidth, height: newHeight)
            }

            let imageRef = image.cgImage!.cropping(to: cropRect)
            let croppedImage = UIImage(cgImage: imageRef!)
            
            return croppedImage
        }
}
