import Foundation
import Alamofire
import RxSwift

class APIClient {
    
    static let apiManager = APIManager.shared

    static func requestFlux(userInput: String, controlImage: String, styleModel: StyleConfigModel, complete: @escaping (String?, Error?) -> ()) {
        let viewModel = CreateViewModel.shared
        let userDefault = UserDefaultService.shared
        let apiKey = apiManager.isUsingLocalKeyValue ? Developer.localKey : apiManager.apiKeyValue
        let endpoint = apiManager.apiEndpointValue.flux
        var fluxModel = apiManager.fluxModelConfigValue
        
        // Update flux model
        let room = viewModel.roomConfigValue.first(where: {$0.id == userDefault.configSetting.roomId})
        let promptConfig = styleModel.prompt.replacingOccurrences(of: Developer.replaceRoom, with: room?.title ?? "").replacingOccurrences(of: Developer.replaceUserInput, with: userInput)
        fluxModel.input.prompt = promptConfig
        fluxModel.input.control_image = "data:application/octet-stream;base64,\(controlImage)"
        
        // Event Create
        AnalyticService.logEventMain(event: Event.create.rawValue, listParameters: [
            Param.value.rawValue: styleModel.name,
            Param.type.rawValue: room?.title ?? ""
        ])
        
        do {
            let data = try JSONEncoder().encode(fluxModel)
            configBodyRequestReplicate(endpoint: endpoint, apiKey: apiKey, model: data)  { urlGet, error in
                complete(urlGet,error)
            }
            
        } catch {}
    }
    
    static func configBodyRequestReplicate(endpoint: String, apiKey: String, model: Data, completion: @escaping (String?, Error?) -> ())  {
        do {
            
            // Make sure the endpoint URL is valid
            guard let url = URL(string: endpoint) else {
                completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
                return
            }
            
            // Prepare the URLRequest
            var request = URLRequest(url: url)
            request.httpBody = model
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
            request.setValue(Developer.bearer + apiKey, forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
            
            // Send the request using Alamofire
            AF.request(request).responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let jsonA = value as? [String: Any] {
                        print("=========> \(jsonA)")
                    }
                    
                    // Parse the JSON response
                    if let json = value as? [String: Any],
                       let urls = json["urls"] as? [String: Any],
                       let getUrl = urls["get"] as? String {
                        completion(getUrl, nil)
                    } else {
                        // Handle case where JSON structure is not as expected
                        completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response structure"]))
                    }
                case .failure(let error):
                    // Pass error to the completion handler
                    completion(nil, error)
                    print("Error: \(error.localizedDescription)")
                }
            }
        } catch {
            // Handle encoding error
            completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode request data"]))
            print("Encoding error: \(error.localizedDescription)")
        }
    }
    
    static func getResultReplicate<T: Decodable>(url: String, completion: @escaping (_ result: T?, _ error: Error?) -> Void) {
        let apiManager = APIManager.shared
        
        let endpoint = url
        
        guard let url = URL(string: endpoint) else {
            print("Invalid URL")
            completion(nil, NSError(domain: "Invalid URL", code: -1, userInfo: nil))
            return
        }
        
        var request = URLRequest(url: url)
        let apiKey = apiManager.isUsingLocalKeyValue ? Developer.localKey : apiManager.apiKeyValue
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue(Developer.bearer + apiKey, forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
        
        AF.request(request).responseDecodable { (response: AFDataResponse<T>) in
            switch response.result {
            case .success(let data):
                completion(data, nil)
            case .failure(let error):
                completion(nil, error)
                print("===> Error: \(error.localizedDescription)")
            }
        }
    }
    

}
