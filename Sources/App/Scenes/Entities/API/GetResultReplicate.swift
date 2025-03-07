
struct ReplicateResultStringOutput: Codable {
    var status: String
    var output: String?
}

struct ReplicateResultArrayOutput: Codable {
    var status: String
    var output: [String]?
}

