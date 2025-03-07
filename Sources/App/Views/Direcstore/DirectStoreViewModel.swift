import Foundation
import UIKit
import RxSwift
import RxCocoa

class DirectStoreViewModel: BaseViewModel {
    static let shared = DirectStoreViewModel.init()
    
    private var modelManager: ModelManager {
        ModelManagerImpl.shared
    }
}

extension DirectStoreViewModel {
    
    // Track ds_limit: Khi vào ds
    func trackLimit(_ value: String) {
        let page = UserDefaultService.shared.dsConfig.type  // ds
        AnalyticService.logEventMain(event: Event.ds_limit.rawValue, listParameters: [
            Param.value.rawValue: value,
            Param.page.rawValue: page
        ])
    }
    
    // Track ds_limit_purchased: Khi purchased thành công
    func trackLimitPurchased(_ value: String, _ productID: String) {
        let page = UserDefaultService.shared.dsConfig.type  // ds
        AnalyticService.logEventMain(event: Event.ds_limit_purchased.rawValue, listParameters: [
            Param.value.rawValue: value,
            Param.item_id.rawValue: productID,
            Param.page.rawValue: page
        ])
    }
    
    // Track ds_onboarding/ ds_launch: Khi từ ob/launch mở ds
    func trackOborLaunch(_ event: String) {
        let page = UserDefaultService.shared.dsConfig.type  // ds
        AnalyticService.logEventMain(event: event, listParameters: [
            Param.page.rawValue: page
        ])
    }
    
    // Track ds_onboarding_purchased/ ds_launch_purchased: Khi từ ob/launch mở ds và purchased thành công
    func trackObLaunchPuchased(_ eventPurchased: String, _ productID: String) {
        let page = UserDefaultService.shared.dsConfig.type  // ds
        let type = OnboardingViewModel.shared.obConfigValue // ob
        
        if eventPurchased == Event.ds_onboarding_purchased.rawValue {
            AnalyticService.logEventMain(event: eventPurchased, listParameters: [
                Param.item_id.rawValue: productID,
                Param.page.rawValue: page,
                Param.type.rawValue: type
            ])
        } else {
            AnalyticService.logEventMain(event: eventPurchased, listParameters: [
                Param.item_id.rawValue: productID,
                Param.page.rawValue: page
            ])
        }
    }
    
    func configPricePerWeek(price: String, divisor: Double) -> String {
        var finalPrice = ""
        let locale = Locale.current
        
        if let usPricePerWeek = dividePricePerWeek(price: price, localeIdentifier: locale.identifier, divisor: divisor) {
            finalPrice = usPricePerWeek
            print("Price per week success: \(usPricePerWeek) \(locale.identifier)")
        } else {
            print("Price per week failed")
        }
        
        return finalPrice
    }
    
    func dividePricePerWeek(price: String, localeIdentifier: String, divisor: Double) -> String? {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: localeIdentifier)
        
        // Loại bỏ ký hiệu tiền tệ và khoảng trắng
        let cleanedPrice = price.replacingOccurrences(of: formatter.currencySymbol ?? "", with: "")
                                .replacingOccurrences(of: formatter.groupingSeparator ?? "", with: "")
        
        // Chuyển đổi chuỗi giá thành số
        guard let priceValue = formatter.number(from: cleanedPrice)?.doubleValue else {
            return nil
        }
        
        // Chia giá cho số tuần và format lại
        let pricePerWeek = priceValue / divisor
        
        if localeIdentifier == "en_VN" {
            // Format giá theo locale
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
            if let formattedPrice = formatter.string(from: NSNumber(value: pricePerWeek)) {
                return formattedPrice
            } else {
                return nil
            }
        } else {
            return formatter.string(from: NSNumber(value: pricePerWeek))
        }
    }
    
    // Tinh gia yearly cua goi weekly (weekly * 48)
    func weeklyPerYear(price: String) -> String {
        var finalPrice = ""
        let locale = Locale.current
        if let usPricePerWeek = divideWeeklyPerYear(price: price, localeIdentifier: locale.identifier) {
            finalPrice = usPricePerWeek
            print("Price per week success: \(usPricePerWeek) \(locale.identifier)")
        } else {
            print("Price per week failed")
        }
        return finalPrice
    }
    
    func divideWeeklyPerYear(price: String, localeIdentifier: String) -> String? {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: localeIdentifier)
        let cleanedPrice = price.replacingOccurrences(of: formatter.currencySymbol ?? "", with: "")
                                .replacingOccurrences(of: formatter.groupingSeparator ?? "", with: "")
        guard let priceValue = formatter.number(from: cleanedPrice)?.doubleValue else {
            return nil
        }
        let pricePerWeek = priceValue * Double(48)
        if localeIdentifier == "en_VN" {
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
            if let formattedPrice = formatter.string(from: NSNumber(value: pricePerWeek)) {
                return formattedPrice
            } else {
                return nil
            }
        } else {
            return formatter.string(from: NSNumber(value: pricePerWeek))
        }
    }
    
    func configSavePercent(weekPrice: String, yearPrice: String) -> String {
        print("PRICE 3: \(weekPrice) - \(yearPrice)")
        guard let weeklyPriceFloat = Float(weekPrice.replacingOccurrences(of: ".", with: "")),
              let yearlyPriceFloat = Float(yearPrice.replacingOccurrences(of: ".", with: "")),
              weeklyPriceFloat != 0 else {
            return "0"
        }
    
        let finalSave = ((weeklyPriceFloat * 48 - yearlyPriceFloat) / (weeklyPriceFloat * 48)) * 100
        let roundedValue = finalSave.rounded()
        let integerValue = Int(roundedValue)
        
        return String(integerValue)
    }
}
