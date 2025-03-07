struct FluxFillDevConfigModel: Codable {
    var input: FluxFillDevModel
}

struct FluxFillDevModel: Codable {
    var mask: String
    var image: String
    var steps: Int
    var prompt: String
    
    var guidance : Int
    var outpaint : String
    var output_format : String
    var safety_tolerance : Int
    var prompt_upsampling: Bool
    

}

