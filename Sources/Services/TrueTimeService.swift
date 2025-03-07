import Foundation
import TrueTime

class TrueTimeService {
    static let shared = TrueTimeService()
    private let client = TrueTimeClient.sharedInstance
    
    private init() {
        client.start()
    }
    
    func fetchCurrentTime(completion: @escaping (Result<Int, Error>) -> Void) {
        client.fetchIfNeeded(completion: { result in
            switch result {
            case .success(let referenceTime):
                let now = referenceTime.now()
                let unixTimestamp = Int(now.timeIntervalSince1970)
                completion(.success(unixTimestamp))
                
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
