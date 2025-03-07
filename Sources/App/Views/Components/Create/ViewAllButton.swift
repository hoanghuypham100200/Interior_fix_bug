import Foundation
import RxSwift
import SnapKit
import UIKit

class ViewAllButton: UIView {
    private lazy var titleLabel = UILabel()
    private lazy var iconImageView = UIImageView()
    public lazy var  button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        titleLabel.setText(text: "View all", color: AppColor.text_view_all)
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        
        iconImageView.setIconSystem(name: "chevron.right", color: AppColor.text_view_all, weight: .regular)
        
    }
    
    private func setupConstraints() {
        addSubview(titleLabel)
        addSubview(iconImageView)
        addSubview(button)
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalTo(iconImageView.snp.leading).inset(-8.scaleX)
        }
        
        iconImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(titleLabel)
            $0.size.equalTo(CGSize(width: 9.scaleX, height: 17.scaleX))
            $0.centerY.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
}
