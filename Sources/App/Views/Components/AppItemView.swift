import Foundation
import RxSwift
import SnapKit
import UIKit

class AppItemView: UIView {
    private lazy var button = UIButton()
    private lazy var iconImageView = UIImageView()
    private lazy var titleLabel = UILabel()
    private lazy var lineView = UIView()
    
    var buttonAction: (() -> Void)?
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        setupRx()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        iconImageView.cornerRadius = 10.scaleX
        iconImageView.clipsToBounds = true
        
        titleLabel.textColor = AppColor.main
        titleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        
        lineView.backgroundColor = AppColor.line_setting
    }
    
    private func setupConstraints() {
        addSubview(button)
        button.addSubview(iconImageView)
        button.addSubview(titleLabel)
        button.addSubview(lineView)
        
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(61.scaleX)
        }
        
        iconImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16.scaleX)
            $0.size.equalTo(CGSize(width: 40.scaleX, height: 40.scaleX))
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview().inset(16.scaleX)
            $0.leading.equalTo(iconImageView.snp.trailing).inset(-12.scaleX)
        }
        
        lineView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.scaleX)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1.scaleX)
        }
    }
    
    private func setupRx() {
        button.rx.tap
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, _ in
                owner.buttonAction?()
            })
            .disposed(by: disposeBag)
    }
    
    public func updateViews(icon: String, title: String, isLast: Bool = false) {
        iconImageView.image = UIImage(named: icon)
        titleLabel.text = title
        
        lineView.snp.updateConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.scaleX)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(isLast ? 0 : 1.scaleX)
        }
    }
}
