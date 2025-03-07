import Foundation
import NVActivityIndicatorView
import GrowingTextView
import SnapKit
import UIKit
import RxSwift
import PanModal

class CreateViewController: BaseViewController {
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    private lazy var chooseThumbView = ChooseThumbView()
    private lazy var selectRoomView = SelectRoomView()
    private lazy var selectStyleView = SelectStyleView()
    private lazy var selectRatioView = SelectRatioView()
    private lazy var inputPromptView = InputPromptView()
    private lazy var generateButton = UIButton()
    
    private let loadingView = NVActivityIndicatorView(frame: .zero, type: .circleStrokeSpin, color: AppColor.yellow_normal_hover, padding: 0)
    
    var chooseImage: UIImage?
    
    var stopGen = false
    let viewModel: CreateViewModel = .init()
    let userDefault = UserDefaultService.shared
    let tabbarViewModel = TabbarViewModel.shared
    var imagePicker: ImagePicker?
    
    var isCanShowDSLaunch = true    // config show ds launch
    var isCanShowInter = false      // config show inter ad
}

extension CreateViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Check show intersitial ad
        // Check daily usage
        viewModel.updateDailyTime { _ in }
        
        // Check show ds launch
        guard isCanShowDSLaunch else {
            if isCanShowInter {
                displayIntersitialAd()
            } else {
                isCanShowInter = true
                if userDefault.adsConfig.interstitialLastTime == 0 {
                    // Set last time khi open app: check khi init app vào screen đầu tiên k show ad
                    userDefault.adsConfig.interstitialLastTime = Int((Date().timeIntervalSince1970).rounded())
                }
            }
            return
        }
        isCanShowDSLaunch = false
        configDsLaunch()
    }
    
    override func setupViews() {
        super.setupViews()
        
        // MARK: set up Views
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        scrollView.showsVerticalScrollIndicator = false
        
        inputPromptView.promptTextView.delegate = self
        inputPromptView.promptTextView.returnKeyType = .done
        
        generateButton.setupBaseButton(title:"DESIGN", icon: R.image.icon_magic_gen() , textColor: AppColor.text_black, backgroundColor: AppColor.yellow_normal_hover, radius: 20, font: UIFont.systemFont(ofSize: 18, weight: .semibold))
        
        addTabbarHeader()
        
        view.addSubview(chooseThumbView)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(chooseThumbView)
        contentView.addSubview(selectRoomView)
        contentView.addSubview(selectStyleView)
        contentView.addSubview(selectRatioView)
        contentView.addSubview(inputPromptView)
        
        // MARK: set up Constraints
        view.addSubview(generateButton)
        view.addSubview(loadingView)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(tabbarHeader.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(generateButton.snp.bottom).inset(-28.scaleX)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
        }
        
        chooseThumbView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(295.scaleX)
        }
        
        selectRoomView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(chooseThumbView.snp.bottom).inset(-20.scaleX)
            $0.height.equalTo(75.scaleX)
        }
        
        selectStyleView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(selectRoomView.snp.bottom).inset(-20.scaleX)
            $0.height.equalTo(182.scaleX)
        }
        
        selectRatioView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(selectStyleView.snp.bottom).inset(-20.scaleX)
            $0.height.equalTo(73.scaleX)
        }
        
        inputPromptView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(selectRatioView.snp.bottom).inset(-20.scaleX)
            $0.height.equalTo(146.scaleX)
            $0.bottom.equalToSuperview().inset(100.scaleX)
        }
        
        generateButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.scaleX)
            $0.bottom.equalTo(view.snp_bottomMargin).inset( 28.scaleX)
            $0.height.equalTo(54.scaleX)
        }
        
        loadingView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50.scaleX, height: 50.scaleX))
            $0.center.equalToSuperview()
        }
        
        configInit()
        
    }
    
    // MARK: Init
    func configInit() {
        let ratioConfigs = viewModel.ratioConfigValue
        let styleConfigs = viewModel.styleConfigValue
        let roomConfigs = viewModel.roomConfigValue
        
        userDefault.configSetting.ratioId = ratioConfigs.first?.id ?? ""
        userDefault.configSetting.styleId = styleConfigs.first?.id ?? ""
        userDefault.configSetting.roomId = roomConfigs.first?.id ?? ""
        
        selectRoomView.setData(roomTypes:  roomConfigs)
        selectStyleView.setData(styles: styleConfigs)
        selectRatioView.setData(ratio: ratioConfigs)
        configRatingPopup()
    }
    
    // MARK: Rx
    override func setupRx() {
        super.setupRx()
        configTapPremiumTabbarHeader()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        NotificationCenter.default.rx
            .notification(UIApplication.didEnterBackgroundNotification)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.hideKeyboard()
            })
            .disposed(by: disposeBag)
        
        // MARK: handle choose Thumb
        chooseThumbView.button.rx.tap
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: {owner, indexPath in
                let modal = ChooseThumbModal()
                modal.delegate = self
                owner.presentPanModal(modal)
            })
            .disposed(by: disposeBag)
        
        chooseThumbView.photosButton.rx.tap
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: {owner, indexPath in
                owner.imagePicker?.present(for: .photoLibrary)
            })
            .disposed(by: disposeBag)
        
        chooseThumbView.cameraButton.rx.tap
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: {owner, indexPath in
                owner.imagePicker?.present(for: .camera)
            })
            .disposed(by: disposeBag)
        
        chooseThumbView.deleteButton.rx.tap
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: {owner, indexPath in
                owner.chooseThumbView.updateView(hasImage: false)
            })
            .disposed(by: disposeBag)
        
        // MARK: select Room View
        selectRoomView.roomCollectionView.rx.itemSelected
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: {owner, indexPath in
                owner.changeRoom(index: indexPath.row)
            })
            .disposed(by: disposeBag)
        
        selectRoomView.viewAllButton.button.rx.tap
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: {owner, indexPath in
                let modal =  RoomModal()
                modal.delegate = self
                owner.presentPanModal(modal)
            })
            .disposed(by: disposeBag)
        
        selectStyleView.styleCollectionView.rx.itemSelected
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: {owner, indexPath in
                let style = owner.viewModel.styleConfigValue[indexPath.row]
                
                if !owner.userDefault.isPurchase && style.isPremium  {
                    owner.openDailyLimitModal(value: Value.style.rawValue)
                }
                
                owner.selectStyleView.styleCollectionView.selectItem(at: IndexPath(item: indexPath.row, section: 0), animated: true, scrollPosition: .centeredHorizontally)
                owner.userDefault.configSetting.styleId = style.id
            })
            .disposed(by: disposeBag)
        
        selectStyleView.viewAllButton.button.rx.tap
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: {owner, indexPath in
                let modal = StyleModal()
                modal.delegate = self
                owner.presentPanModal(modal)
            })
            .disposed(by: disposeBag)
        
        generateButton.rx.tap
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: {owner, indexPath in
                owner.checkBeforeGen()
            })
            .disposed(by: disposeBag)
        
        viewModel.genWhenRwDismissCreateOsb
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, isGen in
                guard isGen else { return }
                Developer.isGenArtByAd = true
                owner.genImage()
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
        
        selectRatioView.ratioCollectionView.rx.itemSelected
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: {owner, indexPath in
                owner.selectRatioView.ratioCollectionView.selectItem(at: IndexPath(item: indexPath.row, section: 0), animated: true, scrollPosition: .centeredHorizontally)
                let ratio = owner.viewModel.ratioConfigValue[indexPath.row]
                owner.userDefault.configSetting.ratioId = ratio.id
                guard let image = owner.chooseImage else {
                    return
                }
                
                let resizedImage = owner.resizeImage(image: image, targetSize: CGSize(width: ratio.width, height: ratio.height))
                let croppedImage = owner.cropImageWithAspectRatio(image: resizedImage, aspectRatio: Double(ratio.width)/Double(ratio.height))
                owner.chooseThumbView.thumbImageView.image = croppedImage
                
            })
            .disposed(by: disposeBag)
        
        viewModel.purchaseObservable
            .withUnretained(self)
            .observe(on: scheduler.main)
            .subscribe(onNext: { owner, value in
                guard owner.userDefault.isPurchase else { return }
                owner.tabbarHeader.checkPurchase(isPurchase: true)
                
                if let index = owner.viewModel.styleConfigValue.firstIndex(where: { $0.id == owner.userDefault.configSetting.styleId }),
                   index < owner.viewModel.styleConfigValue.count {
                    owner.selectStyleView.styleCollectionView.reloadData()
                    owner.selectStyleView.styleCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
                } else {
                    owner.userDefault.configSetting.styleId = owner.viewModel.styleConfigValue.first?.id ?? ""
                    owner.selectStyleView.setData(styles: owner.viewModel.styleConfigValue)
                }
            })
            .disposed(by: disposeBag)
    }
    
    // rating
    func configRatingPopup() {
        guard viewModel.ratingConfigValue.home.enable else { return }
        guard userDefault.ratingConfig.isFirstHome else { return }
        userDefault.ratingConfig.isFirstHome = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.ratingDefaultPopup()
        }
    }
    
    func cropImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let imageSize = image.size
        
        // Tính toán CGRect để cắt từ giữa
        let cropRect = CGRect(
            x: (imageSize.width - targetSize.width) / 2,
            y: (imageSize.height - targetSize.height) / 2,
            width: targetSize.width,
            height: targetSize.height
        )
        
        // Cắt ảnh
        guard let cgImage = image.cgImage?.cropping(to: cropRect) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
    
    
    func checkBeforeGen() {
        
        // Check limit idea
        guard inputPromptView.promptTextView.text.count <= viewModel.limitConfigValue.input_idea else  {
            popupLimit(featureName: "idea", limit: viewModel.limitConfigValue.input_idea)
            return
        }
        
        guard let style = viewModel.styleConfigValue.first(where: {$0.id == userDefault.configSetting.styleId}) else {
            popupError(messageError: "Style null")
            return
        }
        
        guard chooseThumbView.thumbImageView.image != nil else {
            popupWarning(title: "Notification", message: "Please provide your image to generate")
            return
        }
        
        guard userDefault.isPurchase || !style.isPremium  else  {
            openDailyLimitModal(value: Value.style.rawValue)
            return
        }
        
        // Check true time
        checkTrueTime()
    }
    
    func checkTrueTime() {
        hideKeyboard()
        loadingView.startAnimating()
        generateButton.isUserInteractionEnabled = false
        viewModel.updateDailyTime { [weak self] result in
            guard let owner = self else { return }
            guard result else { return }
            DispatchQueue.main.async {
                owner.generateButton.isUserInteractionEnabled = true
                owner.viewModel.checkGen(loadingView: owner.loadingView,
                                         viewController: owner,
                                         popupUsageEnough: {
                    // Popup enough
                    owner.popupUsageEnough()
                }, requestGen: {
                    Developer.isGenArtByAd = false
                    owner.genImage()
                }, openDsLimit: {
                    // Open ds
                    owner.openDailyLimitModal(value: Value.ad.rawValue)
                }, showRwPopup: {
                    // Show popup rw
                    owner.tabbarViewModel.updateShowRwPopupCreate(isShow: true)
                })
            }
        }
    }
    
    // MARK: DS launch
    func configDsLaunch() {
        print("===> isPurchase: \(userDefault.isPurchase)")
        if userDefault.isFirstHome == true {
            userDefault.isFirstHome = false
        } else {
            guard !userDefault.isPurchase else { return }
            let dsVC = AppRouter.makeDirectStoreLaunch()
            present(dsVC, animated: true)
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let padding = Developer.isHasNortch ? 260 : 225
        configViewWithKeyboard(padding: padding)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        configViewWithKeyboard(padding: 28)
        scrollView.scrollToBottom(animated: true)
    }
    
    func configViewWithKeyboard(padding: Int) {
        generateButton.snp.updateConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.scaleX)
            $0.bottom.equalTo(view.snp_bottomMargin).inset(padding.scaleX)
            $0.height.equalTo(54.scaleX)
        }
        
        scrollView.setContentOffset(CGPoint(x: 0, y: 360), animated: true)
    }
    
    func changeRoom(index: Int) {
        selectRoomView.roomCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        let room = viewModel.roomConfigValue[index]
        userDefault.configSetting.roomId = room.id
    }
    
    func changeStyle(index: Int) {
        let style = viewModel.styleConfigValue[index]
        if style.isPremium && !userDefault.isPurchase {
            openDailyLimitModal(value: Value.style.rawValue)
        }
        selectStyleView.styleCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        userDefault.configSetting.styleId = style.id
    }
    
    func genImage() {
        // MARK: proxy
        guard !isConnectedToProxy() else {
            popupProxy()
            return
        }
        
        guard let styleModel = viewModel.styleConfigValue.first(where: {$0.id == userDefault.configSetting.styleId}),
              let roomModel = viewModel.roomConfigValue.first(where: {$0.id == userDefault.configSetting.roomId})
        else {
            popupError(messageError: "Style null")
            return
        }
        
        guard let dataImage = chooseThumbView.thumbImageView.image else {
            popupWarning(title: "Notification", message: "Please provide your image to generate")
            return
        }
        
        var cropSizeSDXL = CGSize()
        
        if let index = viewModel.ratioConfigValue.firstIndex(where: { $0.id == userDefault.configSetting.ratioId}) {
            cropSizeSDXL = CGSize(width: viewModel.ratioConfigValue[index].width, height: viewModel.ratioConfigValue[index].height)
        }
        let resizedImage = resizeImage(image: dataImage, targetSize: CGSize(width: cropSizeSDXL.width, height: cropSizeSDXL.height))
        let croppedImage = cropImageWithAspectRatio(image: resizedImage, aspectRatio: Double(cropSizeSDXL.width)/Double(cropSizeSDXL.height))
        guard let base64Image = croppedImage?.convertImageToBase64String(img: croppedImage ?? resizedImage) else { return }
        let prompt = inputPromptView.promptTextView.text ?? ""
        stopGen = false
        tabbarViewModel.updateShowProccessingView(isShow: true)
        
        viewModel.requestFlux(userInput: prompt, controlImage: base64Image, styleModel: styleModel)
            .flatMap { [weak self] url in
                return self?.viewModel.pollGetReplicateResultStringOutput(url: url) ?? .empty()
            }
            .subscribe(on: scheduler.background)
            .observe(on: scheduler.main)
            .subscribe(onNext: { [weak self] result in
                guard let owner = self else { return }
                guard !owner.stopGen else { return }
                guard let url = result.output else { return }
                
                let idArtwork = String(Int64((Date().timeIntervalSince1970).rounded()))
                let artworkModel = ArtworkModel(id: idArtwork, style: styleModel.name, prompt: prompt, room: roomModel.title , url: url)
                HistoryViewModel.shared.updateArtWork(artWorkModel: artworkModel, artworkImage: croppedImage ?? resizedImage)
                owner.tabbarViewModel.updateShowProccessingView(isShow:false)
                if owner.viewModel.usageLeftValue <= 0 {
                    owner.viewModel.updateMaxCreationRwAd()
                }
               
                owner.viewModel.updateUsage()
                owner.openResultViewController(artwork: artworkModel)
            }, onError: { [weak self] error in
                guard let owner = self else { return }
                owner.tabbarViewModel.updateShowProccessingView(isShow: false)
                owner.popupError(messageError: error.localizedDescription)
                return
            })
            .disposed(by: disposeBag)
    }
    
    func openResultViewController(artwork: ArtworkModel) {
        let resultView = ResultViewController()
        resultView.updateData(artwork: artwork)
        navigationController?.pushViewController(resultView, animated: true)
    }
}

// MARK: Text view
extension CreateViewController: GrowingTextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    // hide keyboard
    func hideKeyboard() {
        inputPromptView.promptTextView.resignFirstResponder()
    }
}

extension CreateViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate ,ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        guard let ratio = viewModel.ratioConfigValue.first(where: {$0.id == userDefault.configSetting.ratioId}) else {
            return
        }
        
        guard let image = image else {
            return
        }
        
        let resizedImage = resizeImage(image: image, targetSize: CGSize(width: ratio.width, height: ratio.height))
        let croppedImage = cropImageWithAspectRatio(image: resizedImage, aspectRatio: Double(ratio.width)/Double(ratio.height))
        
        chooseImage = image
        chooseThumbView.thumbImageView.image = croppedImage
        chooseThumbView.updateView(hasImage: true)
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

extension CreateViewController: ChangeRoomDelegate, ChangeStyleDelegate, ChooseThumbDelegate {
    func chooseThumb(isPhoto: Bool) {
        imagePicker?.present(for: isPhoto ? .photoLibrary : .camera)
    }
    
    func updateRoom(index: Int) {
        changeRoom(index: index)
    }
    
    func updateStyle(index: Int) {
        changeStyle(index: index)
    }
}
