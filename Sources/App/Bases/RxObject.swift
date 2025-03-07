import Foundation
import RxSwift

open class RxObject: NSObject {
    public private(set) var disposeBag = DisposeBag()

    /// Class's constructors.
    public override init() {
        super.init()
    }

    /// Class's destructor.
    deinit {}

    // MARK: Class's public properties
}

// MARK: Class's public methods

extension RxObject {}

// MARK: Class's private methods

private extension RxObject {}
