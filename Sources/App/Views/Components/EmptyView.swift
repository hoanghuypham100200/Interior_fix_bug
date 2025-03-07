import Foundation
import SnapKit
import UIKit

class EmptyView: UIView {
    public lazy var centerView = UIView()
    private lazy var iconEmpty = UIImageView()
    private lazy var desLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        backgroundColor = AppColor.bg_1
        
        iconEmpty.image = R.image.icon_empty()
        iconEmpty.contentMode = .scaleAspectFit
        
        desLabel.setText(text: "Your history is empty.\nStart gen now!", color: AppColor.text_gray)
        desLabel.font = .systemFont(ofSize: 14)
        desLabel.numberOfLines = 2
        desLabel.textAlignment = .center
    }
    
    private func setupConstraints() {
        addSubview(centerView)
        centerView.addSubview(iconEmpty)
        centerView.addSubview(desLabel)
        
        centerView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        iconEmpty.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 40.scaleX, height: 40.scaleX))
        }
        
        desLabel.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(iconEmpty.snp.bottom).inset(-10.scaleX)
        }
    }
}
