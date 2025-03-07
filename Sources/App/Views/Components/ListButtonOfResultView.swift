import Foundation
import UIKit
import SnapKit

class ListButtonOfResultView: UIView {
    public lazy var deleteButton = UIButton()
    private lazy var titleDeleteLabel = UILabel()
    public lazy var shareButton = UIButton()
    private lazy var titleShareLabel = UILabel()
    public lazy var saveButton = UIButton()
    private lazy var titleSaveLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        deleteButton.backgroundColor = AppColor.light_action
        deleteButton.layer.cornerRadius = 23.scaleX
        deleteButton.setSystemIcon("trash", pointSize: 22,weight: .regular)
        
        titleDeleteLabel.setText(text: "Delete", color: AppColor.yellow_dark)
        titleDeleteLabel.font = .systemFont(ofSize: 12, weight: .medium)
        
        saveButton.backgroundColor = AppColor.light_action
        saveButton.layer.cornerRadius = 23.scaleX
        saveButton.setSystemIcon("square.and.arrow.down", pointSize: 22,weight: .regular)
        
        titleSaveLabel.setText(text: "Save", color: AppColor.yellow_dark)
        titleSaveLabel.font = .systemFont(ofSize: 12, weight: .medium)
        
        shareButton.backgroundColor = AppColor.light_action
        shareButton.layer.cornerRadius = 23.scaleX
        shareButton.setSystemIcon("arrowshape.turn.up.right", pointSize: 22,weight: .regular)
        
        titleShareLabel.setText(text: "Share", color: AppColor.yellow_dark)
        titleShareLabel.font = .systemFont(ofSize: 12, weight: .medium)
    }
    
    private func setupConstraints() {
        addSubview(deleteButton)
        addSubview(titleDeleteLabel)
        addSubview(saveButton)
        addSubview(titleSaveLabel)
        addSubview(shareButton)
        addSubview(titleShareLabel)
        
        deleteButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(42.scaleX)
            $0.size.equalTo(CGSize(width: 46.scaleX, height: 46.scaleX))
        }
        
        titleDeleteLabel.snp.makeConstraints {
            $0.centerX.equalTo(deleteButton)
            $0.top.equalTo(deleteButton.snp.bottom).inset(-5.scaleX)
        }
        
        saveButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 46.scaleX, height: 46.scaleX))
        }
        
        titleSaveLabel.snp.makeConstraints {
            $0.centerX.equalTo(saveButton)
            $0.top.equalTo(saveButton.snp.bottom).inset(-5.scaleX)
        }
        
        shareButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(42.scaleX)
            $0.size.equalTo(CGSize(width: 46.scaleX, height: 46.scaleX))
        }
        
        titleShareLabel.snp.makeConstraints {
            $0.centerX.equalTo(shareButton)
            $0.top.equalTo(shareButton.snp.bottom).inset(-5.scaleX)
        }
    }
    
}


