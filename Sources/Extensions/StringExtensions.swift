import CommonCrypto
import Foundation
import UIKit

extension String {
    
    func lastWord() -> String {
        return String(self.split(separator: " ").last ?? "")
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func isSpace() -> Bool {
        return self == " "
    }
    
    func getFileName() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }
    
    func getFileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }
    func trunc(length: Int, trailing: String = "…") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }
    
    func aesEncrypt(key: String = Developer.itcAppID, iv: String = Developer.supportEmail, options: Int = kCCOptionPKCS7Padding) -> String? {
        if let keyData = key.data(using: String.Encoding.utf8),
           let data = self.data(using: String.Encoding.utf8),
           let cryptData = NSMutableData(length: Int((data.count)) + kCCBlockSizeAES128) {
            let keyLength = size_t(kCCKeySizeAES128)
            let operation: CCOperation = UInt32(kCCEncrypt)
            let algoritm: CCAlgorithm = UInt32(kCCAlgorithmAES128)
            let options: CCOptions = UInt32(options)
            
            var numBytesEncrypted: size_t = 0
            
            let cryptStatus = CCCrypt(operation,
                                      algoritm,
                                      options,
                                      (keyData as NSData).bytes, keyLength,
                                      iv,
                                      (data as NSData).bytes, data.count,
                                      cryptData.mutableBytes, cryptData.length,
                                      &numBytesEncrypted)
            
            if UInt32(cryptStatus) == UInt32(kCCSuccess) {
                cryptData.length = Int(numBytesEncrypted)
                let base64cryptString = cryptData.base64EncodedString(options: .lineLength64Characters)
                return base64cryptString
            } else {
                return nil
            }
        }
        return nil
    }
    
    func aesDecrypt(key: String = Developer.itcAppID, iv: String = Developer.supportEmail, options: Int = kCCOptionPKCS7Padding) -> String? {
        if let keyData = key.data(using: String.Encoding.utf8),
           let data = NSData(base64Encoded: self, options: .ignoreUnknownCharacters),
           let cryptData = NSMutableData(length: Int((data.length)) + kCCBlockSizeAES128) {
            let keyLength = size_t(kCCKeySizeAES128)
            let operation: CCOperation = UInt32(kCCDecrypt)
            let algoritm: CCAlgorithm = UInt32(kCCAlgorithmAES128)
            let options: CCOptions = UInt32(options)
            
            var numBytesEncrypted: size_t = 0
            
            let cryptStatus = CCCrypt(operation,
                                      algoritm,
                                      options,
                                      (keyData as NSData).bytes, keyLength,
                                      iv,
                                      data.bytes, data.length,
                                      cryptData.mutableBytes, cryptData.length,
                                      &numBytesEncrypted)
            
            if UInt32(cryptStatus) == UInt32(kCCSuccess) {
                cryptData.length = Int(numBytesEncrypted)
                let unencryptedMessage = String(data: cryptData as Data, encoding: String.Encoding.utf8)
                return unencryptedMessage
            } else {
                return nil
            }
        }
        return nil
    }
    
    func insertSpacing() -> String {
        "  \(self)  "
    }
    
    static func stroke(font: UIFont, strokeWidth: Float, insideColor: UIColor, strokeColor: UIColor) -> [NSAttributedString.Key: Any] {
        return [
            NSAttributedString.Key.strokeColor : strokeColor,
            NSAttributedString.Key.foregroundColor : insideColor,
            NSAttributedString.Key.strokeWidth : -strokeWidth,
            NSAttributedString.Key.font : font
        ]
    }
}

extension CaseIterable where Self: Equatable {
    var index: Self.AllCases.Index? {
        return Self.allCases.firstIndex { self == $0 }
    }
}

func configPerWeekOfYearly(priceYearly: String, symbol: String) -> String {
    if let priceDouble = Double(priceYearly) {
        let config = priceDouble / 48
        return "\(Double(round(100 * config) / 100))\(symbol)"
    } else {
        return ""
    }
}

func configPricePerWeek(price: String) -> String {
    var finalPrice = ""
    let stringValue = price
    let divisor = 48.0

    if let number = Double(stringValue) {
        let result = number / divisor
        let roundedResult = (result * 100).rounded() / 100
        let formattedResult = String(format: "%.2f", roundedResult)
    
        finalPrice = formattedResult
    } else {
        print("Can't converted.")
    }
    
    return finalPrice
}

func configSavePercent(weekPrice: String, yearPrice: String) -> String {
    let weeklyPrice = Double(weekPrice) ?? 0
    let yearlyPrice = Double(yearPrice) ?? 0
    let finalSave = ((weeklyPrice * 48 - yearlyPrice) / (weeklyPrice * 48)) * 100
    let roundedValue = finalSave.rounded()
    let integerValue = Int(roundedValue)

    return String(integerValue)
}
