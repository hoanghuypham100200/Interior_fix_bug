import Foundation

class JsonService {
    
    static let shared = JsonService.init()
    
    func getDataOnboarding(versionID: OnboardingType, completion: @escaping([OnboardingItem]?) -> ()) {
        if let path = Bundle.main.path(forResource: "data_onboarding", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let result = try JSONDecoder().decode([OnboardingVersion].self, from: data)
                
                if let index = result.firstIndex(where: { $0.version == versionID.rawValue }) {
                    let obItems = result[index].data
                    completion(obItems)
                }
            } catch {
                // handle error
                completion(nil)
            }
        } else {
            completion(nil)
        }
    }
    
    func getDataFromFileName<T: Codable>(fileName: String, completion: @escaping(_ result: [T]?) -> Void) {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let result = try JSONDecoder().decode([T].self, from: data)
                completion(result)
            } catch {
                // handle error
                completion(nil)
            }
        } else {
            completion(nil)
        }
    }
    
}
