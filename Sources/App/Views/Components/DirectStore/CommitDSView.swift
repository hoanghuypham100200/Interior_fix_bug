import Foundation
import SnapKit
import UIKit

class CommitDSView: UIView {
    private lazy var unlimitedCommit = ItemCommitDS()
    private lazy var removeAdsCommit = ItemCommitDS ()
    private lazy var premiumCommit = ItemCommitDS()
    private lazy var fasterCommit = ItemCommitDS()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        self.backgroundColor = .clear
        
        unlimitedCommit.updateTitle(title: "Unlimited Use")
        removeAdsCommit.updateTitle(title: "Remove Ads")
        premiumCommit.updateTitle(title: "Premium Styles")
        fasterCommit.updateTitle(title: "Faster Processing")
    }
    
    private func setupConstraints() {
        addSubview(unlimitedCommit)
        addSubview(removeAdsCommit)
        addSubview(premiumCommit)
        addSubview(fasterCommit)
        
        unlimitedCommit.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.size.equalTo(CGSize(width: 150.scaleX, height: 17.scaleX))
        }
        
        removeAdsCommit.snp.makeConstraints {
            $0.top.equalTo(unlimitedCommit.snp.bottom).inset(-6.scaleX)
            $0.leading.equalToSuperview()
            $0.size.equalTo(CGSize(width: 150.scaleX, height: 17.scaleX))
        }
        
        premiumCommit.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(unlimitedCommit.snp.trailing)
            $0.size.equalTo(CGSize(width: 150.scaleX, height: 17.scaleX))
        }
        
        fasterCommit.snp.makeConstraints {
            $0.top.equalTo(unlimitedCommit.snp.bottom).inset(-6.scaleX)
            $0.leading.equalTo(removeAdsCommit.snp.trailing)
            $0.size.equalTo(CGSize(width: 150.scaleX, height: 17.scaleX))
        }
      
    }
}

class ItemCommitDS: UIView {
    private lazy var iconCommit = UIImageView()
    private lazy var titleCommitLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        titleCommitLabel.textColor = AppColor.text_black_patriona
        titleCommitLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        
        iconCommit.setIconSystem(name: "checkmark", color: AppColor.yellow_normal_hover, weight: .medium, sizeIcon: 14)
        iconCommit.contentMode = .scaleAspectFit
    }
    
    private func setupConstraints() {
       
        addSubview(iconCommit)
        addSubview(titleCommitLabel)
        
        iconCommit.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(2.scaleX)
            $0.size.equalTo(CGSize(width: 13.scaleX, height: 13.scaleX))
        }
        
        titleCommitLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(iconCommit.snp.trailing).inset(-10.scaleX)
        }
    }
    
    public func updateTitle(title: String) {
        titleCommitLabel.text = title
    }
}

