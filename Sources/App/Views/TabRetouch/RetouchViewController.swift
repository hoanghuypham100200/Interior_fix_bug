import Foundation
import UIKit
import SnapKit

class RetouchViewController: BaseViewController {
    
    
    private lazy var imageBgImageView = UIImageView()
    
    private lazy var exampleView = UIView()
    private lazy var exampleLabel = UILabel()
    private lazy var exampleIconImage = UIImageView()
    
    private lazy var titleLabel = UILabel()
    private lazy var descLabel = UILabel()
    
    private lazy var frameButtonView = UIView()
    public lazy var cameraButton = ChooseButton()
    public lazy var photosButton = ChooseButton()
    
    private lazy var exampleRetouchView = ExampleRetouchView()
    
    private let viewModel: RetouchViewModel = .init()
    private let userDefault = UserDefaultService.shared

    var imagePicker: ImagePicker?
    var chooseImage: UIImage?

    var itemCount = 0
    var isFisrtLoad = true
    var isLoading = false
    var isLogoMode = true
}

extension RetouchViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Check show intersitial ad
        displayIntersitialAd()
    }
    // MARK: setupViews
    override func setupViews() {
        super.setupViews()
        // header
        tabbarHeader.setupHeaderRetouch()
        
        imageBgImageView.image = R.image.bg_image_retouch()
        imageBgImageView.contentMode = .scaleAspectFill
        imageBgImageView.isUserInteractionEnabled = true
        imageBgImageView.clipsToBounds = true
        
        exampleView.backgroundColor = AppColor.bg_ds.withAlphaComponent(0.7)
        exampleView.layer.cornerRadius = 30
        
        exampleLabel.text = "Put a cabinet insted of a tree"
        exampleLabel.textColor = .black
        exampleLabel.font = UIFont.systemFont(ofSize: 18,weight: .regular)
        
        exampleIconImage.image = UIImage(systemName: "sparkles", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .regular))
        exampleIconImage.tintColor = .black
        
        
        titleLabel.text = "Retouch"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 28,weight: .bold)
        
        descLabel.text = "Mark, retouch, and reimagine your space with AI"
        descLabel.textColor = .white
        descLabel.font = UIFont.systemFont(ofSize: 18,weight: .regular)
        descLabel.textAlignment = .center
        descLabel.numberOfLines = 0
        
        cameraButton.baseSetup(color: AppColor.text_black_patriona, title: "Camera", icon: "camera.fill", weight:.semibold, textSize: 14)
        
        photosButton.baseSetup(color: AppColor.text_black_patriona, title: "Photos", icon: "photo.fill", weight:.semibold, textSize: 14)
        
        
        //MARK: Constaints
        view.addSubview(imageBgImageView)
        view.addSubview(exampleRetouchView)
        imageBgImageView.addSubview(tabbarHeader)
        imageBgImageView.addSubview(exampleView)
        exampleView.addSubview(exampleIconImage)
        exampleView.addSubview(exampleLabel)
        imageBgImageView.addSubview(titleLabel)
        imageBgImageView.addSubview(descLabel)
        imageBgImageView.addSubview(frameButtonView)
        frameButtonView.addSubview(cameraButton)
        frameButtonView.addSubview(photosButton)
        
        imageBgImageView.snp.makeConstraints {
            $0.top.trailing.leading.equalToSuperview()
            $0.height.equalTo(Developer.isHasNortch ? 526.scaleX : 426.scaleX)
            
        }
        
        tabbarHeader.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(-17.scaleX)
            $0.height.equalTo(52.scaleX)
        }
        
        exampleView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(tabbarHeader.snp.bottom).inset(-20.scaleX)
            $0.height.equalTo(60.scaleX)
        }
        
        exampleIconImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(42.scaleX)
        }
        
        exampleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(exampleIconImage.snp.trailing ).inset(-5.scaleX)
        }
        
        frameButtonView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20.scaleX)
            $0.height.equalTo(60.scaleX)
        }
        
        cameraButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 121, height: 60))
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(70.scaleX)
        }
        
        photosButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 121, height: 60))
            $0.bottom.equalToSuperview()
            $0.leading.equalTo(cameraButton.snp.trailing).inset(-10.scaleX)
        }
        
        descLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(frameButtonView.snp.top).inset(-37.scaleX)
            $0.width.equalTo(260.scaleX)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(descLabel.snp.top).inset(-15.scaleX)
        }
        
        exampleRetouchView.snp.makeConstraints {
            $0.top.equalTo(imageBgImageView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    //MARK: setupRx
    override func setupRx() {
        super.setupRx()
        configInit()
        didSelectExample()
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        // MARK: Header
        configTapPremiumTabbarHeader()
        
        photosButton.rx.tap
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: {owner, indexPath in
                owner.imagePicker?.present(for: .photoLibrary)
            })
            .disposed(by: disposeBag)
        
        cameraButton.rx.tap
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: {owner, indexPath in
                owner.imagePicker?.present(for: .camera)
            })
            .disposed(by: disposeBag)
        
        viewModel.purchaseObservable
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, value in
                guard owner.userDefault.isPurchase else { return }
                owner.tabbarHeader.checkPurchase(isPurchase: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func didSelectExample() {
        exampleRetouchView.selectAction = { example in
         
            let resultVC = ResultViewController()

            //if assign id check bug in resultVC
            resultVC.updateData(artwork: ArtworkModel(id: "", style: "", prompt: "", room: "", url: example?.thumbEdit ?? ""))
            resultVC.ExampleRetouchImage = example?.thumbUrl

            self.navigationController?.pushViewController(resultVC, animated: true)
        }
    }
}

extension RetouchViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate ,ImagePickerDelegate {
    
    
    func configInit() {
        let exampleConfigs = viewModel.exampleConfigValue
      
        userDefault.configSetting.exampleId = exampleConfigs.first?.id ?? ""
 
        exampleRetouchView.setData(example: exampleConfigs)
    }
    
    func didSelect(image: UIImage?) {
        let sizeImage = 344
        guard let image = image else {
            return
        }
        
        let resizedImage = resizeImage(image: image, targetSize: CGSize(width: sizeImage.scaleX, height: sizeImage.scaleX))
        let croppedImage = cropImageWithAspectRatio(image: resizedImage, aspectRatio: Double(sizeImage)/Double(sizeImage))
        
        chooseImage = croppedImage
        
        if let chooseImage = chooseImage {
            let editVC = EditViewController()
            let artWork = ArtworkModel(id: "", style: "optional", prompt: "", room: "optional" , url: "")
            editVC.updateImage(image: chooseImage, artWork: artWork)
            self.navigationController?.pushViewController(editVC, animated: true)
        }
      
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Determine the scale factor to maintain the aspect ratio
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Calculate new size based on the scale factor
        let newSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
        
        // Create a new rectangle with the new size
        let rect = CGRect(origin: .zero, size: newSize)
        
        // Render the new image
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    // Function to crop the image to a specific aspect ratio
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
