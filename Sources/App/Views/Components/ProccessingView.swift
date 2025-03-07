import Foundation
import UIKit
import SnapKit
import Lottie

class ProccessingView: UIView {
    private lazy var centerView = UIView()
    private lazy var titleLabel = UILabel()
    public lazy var cancelButton = UIButton()
    public lazy var animationView = LottieAnimationView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        
        backgroundColor = AppColor.text_black
        
        titleLabel.setText(text: "Your room is being designed...", color: AppColor.bg_1)
        titleLabel.font = UIFont.appFont(size: 24)
        
        animationView = LottieAnimationView.init(name: "generating_loading_anim")
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.loopMode = .autoReverse
        animationView.contentMode = .scaleAspectFill
        animationView.tintColor = AppColor.bg_view_1
        cancelButton.cancelRequestButton()
        animationView.play()
        
    }
    
    private func setupConstraints() {
        addSubview(centerView)
        centerView.addSubview(animationView)
        centerView.addSubview(titleLabel)
        addSubview(cancelButton)
        
        centerView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
        }
        
        animationView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).inset(50.scaleX)
            $0.size.equalTo(CGSize(width: 123, height: 129*2))
            $0.bottom.equalToSuperview()
        }
        
        
        cancelButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(200.scaleX)
            $0.height.equalTo(54.scaleX)
        }
        
    }
    
}

