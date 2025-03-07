import Foundation

struct FluxConfigModel: Codable {
    var input: FluxModel
}

struct FluxModel: Codable {
    var steps: Int
    var prompt: String
    var guidance: Int
    var control_image: String
    var output_format: String
    var safety_tolerance: Int
    var prompt_upsampling: Bool
}
