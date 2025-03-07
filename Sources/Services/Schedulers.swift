import Foundation
import RxSwift

struct Schedulers {
    let main = MainScheduler.instance
    let background = SerialDispatchQueueScheduler.init(qos: .background)
    let utility = SerialDispatchQueueScheduler.init(qos: .utility)
    let userInitiated = SerialDispatchQueueScheduler.init(qos: .userInteractive)
}

let scheduler = Schedulers()
