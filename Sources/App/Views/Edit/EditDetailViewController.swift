import Foundation
import NVActivityIndicatorView
import GrowingTextView
import SnapKit
import UIKit
import RxSwift

protocol EditDetailViewControllerDelegate: AnyObject {
    func didFinishDrawing(image: UIImage?)
}

class EditDetailViewController: BaseViewController {
    weak var delegate: EditDetailViewControllerDelegate?

    private lazy var containerView = UIView()
    private lazy var frameThumbView = UIView()
    private lazy var oldImageView = UIImageView()
    public lazy var drawingImageView = UIImageView()
    public lazy var inputEditDetailView = InputEditDetailView()

    public lazy var discardButton = ChooseButton()
    public lazy var UseMaskButton = ChooseButton()
    
    let viewModel: EditViewModel = .init()
    let userDefault = UserDefaultService.shared
    var artwork: ArtworkModel?
    

    private var lastPoint: CGPoint?
    private var isEraserMode = false
}

extension EditDetailViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.updateDailyTime { _ in }
        displayIntersitialAd()
       
    }

    override func setupViews() {
        super.setupViews()
      
        drawingImageView.layer.cornerRadius = 15
        drawingImageView.clipsToBounds = true
        drawingImageView.isUserInteractionEnabled = true
        drawingImageView.layer.zPosition = 10
        drawingImageView.alpha = 0.5 // make brush line alpha 0.5

        oldImageView.contentMode = .scaleAspectFit
        oldImageView.clipsToBounds = true
        oldImageView.layer.cornerRadius = 15

        
        discardButton.baseSetup(color: AppColor.text_black_patriona, title: "Discard", icon: "xmark.circle", weight:.regular, textSize: 18)
        
        UseMaskButton.baseSetup(color: AppColor.text_black_patriona, title: "Use Mask", icon: "checkmark.circle", weight:.regular, textSize: 18)


        view.addSubview(containerView)
        containerView.addSubview(inputEditDetailView)
        containerView.addSubview(frameThumbView)
        containerView.addSubview(discardButton)
        containerView.addSubview(UseMaskButton)

        frameThumbView.addSubview(drawingImageView)
        frameThumbView.addSubview(oldImageView)
       

        //MARK: Constraints
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        frameThumbView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.size.equalTo(CGSize(width: 344.scaleX, height: 344.scaleX))
        }
        
        drawingImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        oldImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        inputEditDetailView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(frameThumbView.snp.bottom).inset(Developer.isHasNortch ? -44.scaleX : -20.scaleX)
            $0.height.equalTo(160.scaleX)
        }
        
        discardButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(35.scaleX)
            $0.size.equalTo(CGSize(width: 173.scaleX, height: 55.scaleX))
            $0.leading.equalToSuperview().inset(16)
        }
        
        UseMaskButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(35.scaleX)
            $0.size.equalTo(CGSize(width: 173.scaleX, height: 55.scaleX))
            $0.leading.equalTo(discardButton.snp.trailing).inset(-15.scaleX)
        }
    }
    

    
    override func setupRx() {
        super.setupRx()
        inputEditDetailView.configButtonIsEraserMode(isEraserMode: false)
        //drawing image
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        drawingImageView.addGestureRecognizer(panGesture)
        
        inputEditDetailView.brushSlider.rx.value
            .subscribe(onNext: { [weak self] value in
                EditViewController.brushWidth = CGFloat(value)

            })
            .disposed(by: disposeBag)
          
        
        inputEditDetailView.brushButton.rx.tap
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: {owner, indexPath in
                self.toggleEraser(isEraserMode: false)
                self.inputEditDetailView.configButtonIsEraserMode(isEraserMode: false)
            })
            .disposed(by: disposeBag)
        
        inputEditDetailView.eraserButton.rx.tap
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: {owner, indexPath in
                self.toggleEraser(isEraserMode: true)
                self.inputEditDetailView.configButtonIsEraserMode(isEraserMode: true)
            })
            .disposed(by: disposeBag)
        
        //dismiss screen
        discardButton.rx.tap
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: {owner, indexPath in
                self.dismiss(animated: true)
                
            })
            .disposed(by: disposeBag)
        
        UseMaskButton.rx.tap
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: {owner, indexPath in
                self.dismiss(animated: true)
                self.delegate?.didFinishDrawing(image: self.drawingImageView.image)
            })
            .disposed(by: disposeBag)
    }
    
    func updateImage(image: UIImage) {
        oldImageView.image = image
    }
    
    @objc private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: drawingImageView)
        if sender.state == .began {
            lastPoint = point
        } else if sender.state == .changed {
            guard let lastPoint = lastPoint else { return }
            draw(from: lastPoint, to: point)
            self.lastPoint = point
        } else if sender.state == .ended {
            lastPoint = nil
        }
    }
    

    private func draw(from startPoint: CGPoint, to endPoint: CGPoint) {
            let renderer = UIGraphicsImageRenderer(size: drawingImageView.bounds.size)
            drawingImageView.image = renderer.image { context in
                drawingImageView.image?.draw(in: drawingImageView.bounds)
                let ctx = context.cgContext
                ctx.setShouldAntialias(true)
                ctx.setAllowsAntialiasing(true)
                ctx.setLineJoin(.round)
                ctx.setLineCap(.round)
                
                if isEraserMode {
                    ctx.setBlendMode(.clear)
                    ctx.setStrokeColor(UIColor.clear.cgColor)
                } else {
                    ctx.setBlendMode(.normal)
                    ctx.setStrokeColor(AppColor.line_draw.cgColor)
                }
                
                // Dùng brushWidth cập nhật từ slider
                ctx.setLineWidth(EditViewController.brushWidth)
                ctx.move(to: startPoint)
                ctx.addLine(to: endPoint)
                ctx.strokePath()
            }
        }

    private func toggleEraser(isEraserMode: Bool) {
        self.isEraserMode = isEraserMode
    }

    private func clearDrawing() {
        drawingImageView.image = nil
    }
}





