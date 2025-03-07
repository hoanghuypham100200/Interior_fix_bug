import Foundation
import SnapKit
import UIKit

class RatingView: UIView {
    private lazy var iconImageView = UIImageView()
    private lazy var thankLabel = UILabel()
    private lazy var desLabel = UILabel()
    public lazy var confirmButton = UIButton()
    public lazy var nothanksButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupViews() {

        self.backgroundColor = AppColor.guBg
        self.cornerRadius = 25.scaleX
        self.clipsToBounds = true
        
        iconImageView.image = R.image.rating_stars()
        iconImageView.contentMode = .scaleAspectFit
        
        thankLabel.setText(text: "Help Us Grow", color: AppColor.text_black)
        thankLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        desLabel.setText(text: "Show your love by giving us\na review on the Appstore", color: AppColor.text_black)
        desLabel.font = .systemFont(ofSize: 14, weight: .medium)
        desLabel.textAlignment = .center
        desLabel.numberOfLines = 2
                
        confirmButton.setupTitleButton(title: "OK, sure", fontWeight: .bold, fontSize: 16, titleColor: AppColor.text_black, bgColor: AppColor.yellow_normal_hover, radius: 25)
        
        let nothanks = NSMutableAttributedString(string: "No, thanks", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: AppColor.text_gray, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        nothanksButton.setAttributedTitle(nothanks, for: .normal)
    }
    
    private func setupConstraints() {
        addSubview(iconImageView)
        addSubview(thankLabel)
        addSubview(desLabel)
        addSubview(confirmButton)
        addSubview(nothanksButton)
        
        thankLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(20.scaleX)
        }
        
        iconImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(thankLabel.snp.bottom).inset(-20.scaleX)
            $0.size.equalTo(CGSize(width: 190.scaleX, height: 40.scaleX))
        }
        
        desLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(iconImageView.snp.bottom).inset(-20.scaleX)
        }
        
        confirmButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(35.scaleX)
            $0.top.equalTo(desLabel.snp.bottom).inset(-20.scaleX)
            $0.height.equalTo(50.scaleX)
        }
        
        nothanksButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(confirmButton.snp.bottom).inset(-15.scaleX)
            $0.bottom.equalToSuperview().inset(20.scaleX)
            $0.height.equalTo(18.scaleX)
        }
    }
}
