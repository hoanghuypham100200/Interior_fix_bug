import Foundation
import NVActivityIndicatorView
import GrowingTextView
import SnapKit
import UIKit
import RxSwift

class EditViewController: BaseViewController {
    private lazy var contentEditView = UIView()
    private lazy var frameThumbView = UIView()
    private lazy var oldImageView = UIImageView()
    private lazy var drawingImageView = UIImageView()
    public lazy var buttonListView = ButtonEditListView()
  
    private lazy var blurEffect = UIBlurEffect(style: .dark)
    private lazy var descBlurEffectView = UIVisualEffectView()
    private lazy var inputPromptView = InputEditPromptView()
    static var brushWidth: CGFloat = 0

    
    var stopGen = false
    let viewModel: EditViewModel = .init()
    let userDefault = UserDefaultService.shared
    var artwork: ArtworkModel?
    
    private let loadingView = NVActivityIndicatorView(frame: .zero, type: .circleStrokeSpin, color: AppColor.yellow_normal_hover, padding: 0)
    private lazy var proccessingView = ProccessingView()

    private lazy var rwOpacityButton = UIButton()
    private lazy var rwOptionPopup = RewardedAdOptionView()
    private let rewardedAdService = RewardedAdService.shared
 
}

extension EditViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.updateDailyTime { _ in }
        displayIntersitialAd()
        drawingImageView.alpha = 0.5

    }

    override func setupViews() {
        super.setupViews()
        //MARK: setup UI
      

        drawingImageView.layer.cornerRadius = 15
        drawingImageView.clipsToBounds = true
        drawingImageView.isUserInteractionEnabled = true
        drawingImageView.layer.zPosition = 2
        
        frameThumbView.layer.cornerRadius = 15
        frameThumbView.layer.borderWidth = 1
        frameThumbView.layer.borderColor = AppColor.guLine2.cgColor
        
        oldImageView.contentMode = .scaleAspectFill
        oldImageView.clipsToBounds = true
        oldImageView.layer.cornerRadius = 15
       
        
        screenHeader.update(title: "Edit")
        
        proccessingView.isHidden = true
        
        descBlurEffectView.effect = blurEffect
        descBlurEffectView.alpha = 0
        inputPromptView.promptTextView.delegate = self
        //rewardedAd
        rewardedAdService.delegate = self
        rwOpacityButton.backgroundColor = AppColor.text_black.withAlphaComponent(0.85)
        rwOpacityButton.isHidden = true
        
        
        addScreenHeader()
        view.addSubview(contentEditView)
        view.addSubview(rwOpacityButton)
        view.addSubview(descBlurEffectView)
        view.addSubview(inputPromptView)
        view.addSubview(proccessingView)
        view.addSubview(loadingView)

        contentEditView.addSubview(buttonListView)
        contentEditView.addSubview(frameThumbView)
        frameThumbView.addSubview(drawingImageView)
        frameThumbView.addSubview(oldImageView)
        rwOpacityButton.addSubview(rwOptionPopup)

        addSavePopupView()
        addRatingView()

        //MARK: setup constraints
        
        contentEditView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(screenHeader.snp.bottom)
            $0.bottom.equalToSuperview()
        }
        
        descBlurEffectView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        frameThumbView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.size.equalTo(CGSize(width: 344.scaleX, height: 344.scaleX))
        }
        
        drawingImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        oldImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        buttonListView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(frameThumbView.snp.bottom).inset(-10.scaleX)
            $0.height.equalTo(60.scaleX)
        }
        
        inputPromptView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(112.scaleX)
            $0.bottom.equalToSuperview().inset(30.scaleX)
        }
        
        
        loadingView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50.scaleX, height: 50.scaleX))
            $0.center.equalToSuperview()
        }
        
        proccessingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        rwOpacityButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        rwOptionPopup.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(320.scaleX)
        }
        
    }

    
    //MARK: RX
    override func setupRx() {
        super.setupRx()
        actionBackScreenHeader()
        configTapSavePopup()
        
        // dimiss key board when tap blurView
        let tapDescBlurView = UITapGestureRecognizer(target: self, action: #selector(DescBlurViewTapped))
        tapDescBlurView.cancelsTouchesInView = false
        descBlurEffectView.addGestureRecognizer(tapDescBlurView)
        
        //auto present editDetail
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.presentEditDetail()
        }
    
        //MARK: Reward ads
        //when reward dismiss
        viewModel.genEditWhenRwDismissCreateOsb
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, isGen in
                guard isGen else { return }
                Developer.isGenArtByAd = true
                owner.genUpdateImage()
            })
            .disposed(by: disposeBag)
        //button blur View
        rwOpacityButton.rx.tap
            .throttle(.milliseconds(300), scheduler: scheduler.main)
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, _ in
                owner.updatehideRW()
            })
            .disposed(by: disposeBag)
        
        rwOptionPopup.premiumButton.rx.tap
            .throttle(.milliseconds(300), scheduler: scheduler.main)
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, _ in
                // Hide rw popup
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    owner.updatehideRW()
                }
                // Open ds
                owner.openDS()
            })
            .disposed(by: disposeBag)
        
        rwOptionPopup.watchAdButton.rx.tap
            .throttle(.milliseconds(300), scheduler: scheduler.main)
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, _ in
                owner.loadRwAd()
            })
            .disposed(by: disposeBag)
        
        viewModel.showRwPopupCreateOsb
            .observe(on: scheduler.main)
            .withUnretained(self)
            .subscribe(onNext: { owner, isShow in
                isShow ? owner.showRwPopup() : owner.hideRwPopup()
            })
            .disposed(by: disposeBag)
        
        
        //MARK: genButton
        
        inputPromptView.genButton.rx.tap
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: {owner, indexPath in
                self.checkBeforeGen()

            })
            .disposed(by: disposeBag)
        
        buttonListView.saveButton.rx.tap
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: {owner, indexPath in

                owner.showPopup(view: owner.savePopupView)

            })
            .disposed(by: disposeBag)
        // show drawing image
        buttonListView.showButton.rx.tap
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: {owner, indexPath in
                self.didTapShowDrawingImage()
            })
            .disposed(by: disposeBag)
        
        savePopupView.rightButton.rx.tap
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: {owner, indexPath in
                owner.hideDeletePopup()
                guard let image = owner.drawingImageView.image else { return }
                owner.saveImage(imageResult: image )
            })
            .disposed(by: disposeBag)
        

        buttonListView.editMarkButton.rx.tap
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: {owner, indexPath in
                
                owner.presentEditDetail()
            })
            .disposed(by: disposeBag)
        // MARK: Loading Rx
        //loading proccessing
        proccessingView.cancelButton.rx.tap
            .throttle(.milliseconds(300), scheduler: scheduler.main)
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, _ in
                owner.viewModel.updateCancelGenView(stopGen: true)
                owner.viewModel.updateShowProccessingView(isShow: false)
            })
            .disposed(by: disposeBag)
        
        viewModel.cancelGenOsb
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, stopGen in
                guard stopGen else { return }
                owner.stopGen = stopGen
            })
            .disposed(by: disposeBag)
        
        viewModel.showProccessingViewOsb
            .observe(on: scheduler.main)
            .withUnretained(self)
            .subscribe(onNext: { owner, isShow in
                isShow ? owner.showProccessingView() : owner.hideProccessingView()
            })
            .disposed(by: disposeBag)
    }
    
    
    //MARK: func Rewark
    func openDS() {
        let dsVC = AppRouter.makeDirectStoreMain(value: Value.ad.rawValue)
        present(dsVC, animated: true)
    }
    
    func hideRwPopup() {
        rwOpacityButton.isHidden = true
    }
    
    func updatehideRW() {
        viewModel.updateShowRwPopupCreate(isShow: false)
    }
    
    // Show rw ad popup
    func showRwPopup() {
        rwOpacityButton.isHidden = false
        rwOptionPopup.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 5.0,
                       options: .allowUserInteraction,
                       animations: {
            self.rwOptionPopup.alpha = 1
            self.rwOptionPopup.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
    }
    
    // MARK: Loading
    func loadingState(isStart: Bool) {
        isStart ? loadingView.startAnimating() : loadingView.stopAnimating()
        rwOpacityButton.isUserInteractionEnabled = !isStart
    }
    
    func loadRwAd() {
        // Start loading
        loadingState(isStart: true)
        
        rewardedAdService.showAd(on: self)
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, hasAd in
                // Stop loading
                owner.loadingState(isStart: false)
                // Hide rw popup
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    owner.updatehideRW()
                }
                
                if !hasAd {
                    // No ad -> Open ds
                    owner.openDS()
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    // load proccess
    func hideProccessingView() {
        proccessingView.isHidden = true
    }
    
    // Show rw ad popup
    func showProccessingView() {
        proccessingView.isHidden = false
    }
    
    //MARK: func textView
    @objc func DescBlurViewTapped() {
        hideKeyboard()
    }
    
    private func showDescBlurView () {
        UIView.animate(withDuration: 0.3) {
            self.descBlurEffectView.alpha = 1
        }
    }
    
    //MARK: func present edit detail

    func presentEditDetail() {
        guard let image = self.oldImageView.image else {
              return
        }
        
        let editDetailVC = EditDetailViewController()
        editDetailVC.modalPresentationStyle = .fullScreen
        editDetailVC.delegate = self
        editDetailVC.drawingImageView.image = self.drawingImageView.image
      
        editDetailVC.updateImage(image: image)
        self.present(editDetailVC, animated: true)
    }
    
    
    
    func hideKeyboard() {
        descBlurEffectView.alpha = 0
        view.endEditing(true)
        inputPromptView.promptTextView.resignFirstResponder()

        inputPromptView.snp.updateConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(112.scaleX)
            $0.bottom.equalToSuperview().inset(30)
        }
    }
    
    
    
    //MARK:  Image black&white
    func getInpaintingImage(inputImage: UIImage) -> UIImage? {
          
           guard let cgImage = inputImage.cgImage else { return nil }
           
           let width = cgImage.width
           let height = cgImage.height
           let bitsPerComponent = 8
           let bytesPerRow = width * 4
           let colorSpace = CGColorSpaceCreateDeviceRGB()
           let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
           
           // Tạo context với nền đen
           guard let context = CGContext(
               data: nil,
               width: width,
               height: height,
               bitsPerComponent: bitsPerComponent,
               bytesPerRow: bytesPerRow,
               space: colorSpace,
               bitmapInfo: bitmapInfo
           ) else { return nil }
           
           // Đổ nền màu đen
           context.setFillColor(UIColor.black.cgColor)
           context.fill(CGRect(x: 0, y: 0, width: width, height: height))
           
           // Vẽ hình ảnh gốc lên context
           context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
           
           guard let pixelBuffer = context.data else { return nil }
           let pixels = pixelBuffer.bindMemory(to: UInt8.self, capacity: width * height * 4)
           
           for y in 0..<height {
               for x in 0..<width {
                   let offset = (y * width + x) * 4
                   let red = pixels[offset]
                   let green = pixels[offset + 1]
                   let blue = pixels[offset + 2]
                   
                   // Kiểm tra màu xanh
                   if red > 200 && green > 200 && blue < 50 { // Giả sử màu xanh gần #0000FF
                       pixels[offset] = 255   // Đặt Red = 255
                       pixels[offset + 1] = 255 // Đặt Green = 255
                       pixels[offset + 2] = 255 // Đặt Blue = 255
                       pixels[offset + 3] = 255 // Đặt Alpha = 255
                   } else {
                       // Các pixel không phải màu xanh sẽ giữ nền đen
                       pixels[offset] = 0     // Đặt Red = 0
                       pixels[offset + 1] = 0 // Đặt Green = 0
                       pixels[offset + 2] = 0 // Đặt Blue = 0
                       pixels[offset + 3] = 255 // Đặt Alpha = 255
                   }
               }
           }
           
           guard let outputCGImage = context.makeImage() else { return nil }
           return UIImage(cgImage: outputCGImage)
       }
    
    //MARK: Check BeforeGen
    func checkBeforeGen() {
        
        // Check limit idea
        guard inputPromptView.promptTextView.text.count <= viewModel.limitConfigValue.input_idea else  {
            popupLimit(featureName: "idea", limit: viewModel.limitConfigValue.input_idea)
            return
        }
        
        guard oldImageView.image != nil else {
            popupWarning(title: "Notification", message: "Please provide your image to generate")
            return
        }
        
        guard drawingImageView.image != nil else {
            popupWarning(title: "Notification", message: "Please provide your brush mark")
            return
        }
        
        guard userDefault.isPurchase  else  {
            openDailyLimitModal(value: Value.style.rawValue)
            return
        }
        
        // Check true time
        checkTrueTime()
    }
    
    //MARK: CheckTrue Time
    func checkTrueTime() {
        hideKeyboard()
        loadingView.startAnimating()
        inputPromptView.genButton.isUserInteractionEnabled = false
        viewModel.updateDailyTime { [weak self] result in
            guard let owner = self else { return }
            guard result else { return }
            DispatchQueue.main.async {
                owner.inputPromptView.genButton.isUserInteractionEnabled = true
                owner.viewModel.checkGen(loadingView: owner.loadingView,
                                         viewController: owner,
                popupUsageEnough: {
                    // Popup enough
                    owner.popupUsageEnough()
                }, requestGen: {
                    Developer.isGenArtByAd = false
                    owner.genUpdateImage()
                }, openDsLimit: {
                    // Open ds
                    owner.openDailyLimitModal(value: Value.ad.rawValue)
                }, showRwPopup: {
                    // Show popup rw
                    owner.viewModel.updateShowRwPopupCreate(isShow: true)
                })
            }
        }
    }
    
    //MARK: generate Image
    func genUpdateImage() {
        hideKeyboard()
        guard let artwork = artwork else {
           return
        }
      
        guard let dataImage = oldImageView.image else {
            popupWarning(title: "Notification", message: "Please provide your image to generate")
            return
        }
        var cropSizeSDXL = CGSize()
        
        // base64 image
        if let index = viewModel.ratioConfigValue.firstIndex(where: { $0.id == userDefault.configSetting.ratioId}) {
            cropSizeSDXL = CGSize(width: viewModel.ratioConfigValue[index].width, height: viewModel.ratioConfigValue[index].height)
        }
        guard let resizedImage = resizeImage(dataImage , targetSize: CGSize(width: 1022, height: 1022)) else { return }
        
        
        let base64ControlImage = resizedImage.convertImageToBase64String(img:  resizedImage)
       
        // base64 mark
        guard let inputMark = drawingImageView.image else { return }
        guard let blackAndWhiteImage = getInpaintingImage(inputImage: inputMark) else { return }
        
        guard let resizedMark = resizeImage(blackAndWhiteImage , targetSize: CGSize(width: 1022, height: 1022)) else { return }
        
        let base64MarkImage = resizedMark.convertImageToBase64String(img: resizedMark)
        
        let prompt = inputPromptView.promptTextView.text ?? ""
        stopGen = false
        viewModel.updateShowProccessingView(isShow: true)
        
        viewModel.requestFluxFillDev(userInput: prompt, controlImage: base64ControlImage, markImage: base64MarkImage)
            .flatMap { [weak self] url in
                print("url",url)
                return self?.viewModel.pollGetReplicateResultStringOutput(url: url) ?? .empty()
                
            }
            .subscribe(on: scheduler.background)
            .observe(on: scheduler.main)
            .subscribe(onNext: { [weak self] result in
                guard let owner = self else { return }
                guard owner.stopGen == false else { return }
                guard let url = result.output else { return }
            
                let artworkModel: ArtworkModel

                if (artwork.id.isEmpty) {
                    guard owner.stopGen == false else { return }
                    artworkModel = ArtworkModel(id: "", style: artwork.style, prompt: artwork.prompt, room: artwork.room , url: url)
                   
                } else {
                    guard owner.stopGen == false else { return }
                    artworkModel = ArtworkModel(id: artwork.id, style: artwork.style, prompt: artwork.prompt, room: artwork.room , url: url)
                    HistoryViewModel.shared.deleteArtWork(artWorkModel: artwork)
                    HistoryViewModel.shared.updateArtWork(artWorkModel: artworkModel, artworkImage:  resizedImage)
                }
                owner.drawingImageView.alpha = 1
                owner.viewModel.updateUsage()

                owner.viewModel.updateShowProccessingView(isShow:false)
                if owner.viewModel.usageLeftValue <= 0 {
                    owner.viewModel.updateMaxCreationRwAd()
                }
                owner.drawingImageView.loadImageKF(thumbURL: artworkModel.url) {_ in}

                
            }, onError: { [weak self] error in
                guard let owner = self else { return }
                owner.viewModel.updateShowProccessingView(isShow: false)
                owner.popupError(messageError: error.localizedDescription)
                return
            })
            .disposed(by: disposeBag)
        
        
        
    }
    
    func didTapShowDrawingImage() {
        drawingImageView.isHidden.toggle()
        guard let inputImage = drawingImageView.image else { return  }
         let blackAndWhiteImage = getInpaintingImage(inputImage: inputImage)
        buttonListView.showButton.setImage(blackAndWhiteImage == nil ? R.image.icon_show() : blackAndWhiteImage, for: .normal)
        buttonListView.showButton.setImage(drawingImageView.isHidden ? nil  : blackAndWhiteImage, for: .normal)

    }
    
    // update from edit Screen from create
    func updateData(artwork: ArtworkModel) {
        self.artwork = artwork
        oldImageView.loadImageKF(thumbURL: artwork.url) { _ in}
      
    }
    
    // update from retouch Screen
    func updateImage(image: UIImage, artWork: ArtworkModel) {
        oldImageView.image = image
        self.artwork = artWork
    }


}

extension EditViewController: GrowingTextViewDelegate, UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        showDescBlurView()
        inputPromptView.snp.updateConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(112.scaleX)
            $0.bottom.equalToSuperview().inset(Developer.isHasNortch ? 330.scaleX : 270.scaleX)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n" {
                hideKeyboard()
            }
            return true
    }
}


extension EditViewController: EditDetailViewControllerDelegate {
    func didFinishDrawing(image: UIImage?) {
        drawingImageView.image = image
        guard let inputImage = drawingImageView.image else { return  }
         let blackAndWhiteImage = getInpaintingImage(inputImage: inputImage)
        buttonListView.showButton.setImage(blackAndWhiteImage == nil ? R.image.icon_show() : blackAndWhiteImage, for: .normal)
    }
    
    func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }

    
    func cropImageWithAspectRatio(image: UIImage, aspectRatio: CGFloat) -> UIImage? {
        let originalWidth = image.size.width
        let originalHeight = image.size.height
        
        // Calculate the target size based on the aspect ratio
        var targetWidth: CGFloat
        var targetHeight: CGFloat
        
        if originalWidth / originalHeight > aspectRatio {
            targetWidth = originalHeight * aspectRatio
            targetHeight = originalHeight
        } else {
            targetWidth = originalWidth
            targetHeight = originalWidth / aspectRatio
        }
        
        // Calculate the cropping rectangle
        let cropRect = CGRect(
            x: (originalWidth - targetWidth) / 2,
            y: (originalHeight - targetHeight) / 2,
            width: targetWidth,
            height: targetHeight
        )
        
        // Crop the image
        if let cgImage = image.cgImage?.cropping(to: cropRect) {
            return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
        }
        
        return nil
    }
    
}

extension EditViewController: RewardedAdServiceDelegate {
    func rwAdDidDismiss() {
        viewModel.updateEditGenWhenRwCreateDismiss(isGen: true)
    }
}
