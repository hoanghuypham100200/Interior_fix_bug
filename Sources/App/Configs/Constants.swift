import UIKit

struct K {
    struct ProductionServer {
        static let baseURL = "https://api.tinyleo.com/api/v1"
    }
    
    struct APIParameterKey {
        static let idGenArt = "id"
        static let context = "context"
        static let upscale = "upscale"
        static let device_tokens = "device_tokens"
        static let width = "width"
        static let height = "height"
        static let guidance_scale = "guidance_scale"
        static let loop_num = "loop_num"
        static let strength = "strength"
        static let init_image = "init_image"
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case contentLength = "Content-Length"
    case x_key = "X-Key"
    case host = "Host"
    case userAgent = "User-Agent"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case connection = "Connection"
    case xRapidAPIKey = "X-RapidAPI-Key"
    case xRapidAPIHost = "X-RapidAPI-Host"
}

enum ContentType: String {
    case json = "application/json"
    case formdata = "multipart/form-data"
}
