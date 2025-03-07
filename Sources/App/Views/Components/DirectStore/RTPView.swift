import Foundation
import SnapKit
import UIKit

class RTPView: UIView {
    public lazy var privacyButton = UIButton()
    public lazy var restoreButton = UIButton()
    public lazy var termButton = UIButton()
    private lazy var line1 = UIView()
    private lazy var line2 = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        let restore = NSMutableAttributedString(string: "Restore Purchase", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .medium), NSAttributedString.Key.foregroundColor: AppColor.ds_rtp])
        restoreButton.setAttributedTitle(restore, for: .normal)
        
        let privacy = NSMutableAttributedString(string: "Policy", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .medium), NSAttributedString.Key.foregroundColor: AppColor.ds_rtp])
        privacyButton.setAttributedTitle(privacy, for: .normal)
        
        let term = NSMutableAttributedString(string: "Terms", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .medium), NSAttributedString.Key.foregroundColor: AppColor.ds_rtp])
        termButton.setAttributedTitle(term, for: .normal)
        
        line1.backgroundColor = AppColor.ds_rtp
        
        line2.backgroundColor = AppColor.ds_rtp
    }
    
    private func setupConstraints() {
        addSubview(restoreButton)
        addSubview(line1)
        addSubview(termButton)
        addSubview(line2)
        addSubview(privacyButton)
        
        restoreButton.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
        
        line1.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 1.scaleX, height: 16.scaleX))
            $0.leading.equalTo(restoreButton.snp.trailing).inset(-8.scaleX)
        }
        
        termButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(line1.snp.trailing).inset(-8.scaleX)
        }
        
        line2.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 1.scaleX, height: 16.scaleX))
            $0.leading.equalTo(termButton.snp.trailing).inset(-8.scaleX)
        }
        
        privacyButton.snp.makeConstraints {
            $0.leading.equalTo(line2.snp.trailing).inset(-8.scaleX)
            $0.trailing.centerY.equalToSuperview()
        }
    }
}
