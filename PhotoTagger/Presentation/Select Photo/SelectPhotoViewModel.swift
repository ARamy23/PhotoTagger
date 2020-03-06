//
//  SelectPhotoViewModel.swift
//  PhotoTagger
//
//  Created by Ahmed Ramy on 3/6/20.
//  Copyright © 2020 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit.UIImage
import Promises
class SelectPhotoViewModel: NSObject {
    
    // MARK: Outputs
    var takePhotoButtonTitle = Dynamic<String>("")
    var photo = Dynamic<UIImage?>(nil)
    var isTakePhotoButtonVisibile = Dynamic<Bool>(true)
    var progressBarProgress = Dynamic<Double>(0.0)
    var isProgressBarVisibile = Dynamic<Bool>(false)
    var shouldAnimateActivityIndicator = Dynamic<Bool>(false)
    
    // MARK: Dependencies
    let network: NetworkProtocol
    let system: SystemProtocol
    let router: RouterProtocol
    let imageSelecter: ImageSelecter
    
    init(network: NetworkProtocol = MoyaManager(),
         system: SystemProtocol = SystemImp(),
         imageSelecter: ImageSelecter = ImageSelecterImp(),
         router: RouterProtocol) {
        self.network = network
        self.system = system
        self.imageSelecter = imageSelecter
        self.router = router
    }
    
    func viewDidLoad() {
        takePhotoButtonTitle.value = generateTakePictureTitle()
    }
    
    private func generateTakePictureTitle() -> String {
        let title = system.isCameraAvailable() ? "Take Photo" : "Select Photo"
        return title
    }
    
    func viewDidDisappear() {
        photo.value = nil
    }
    
    func takePicture() {
        let imageSource: ImageSource = system.isCameraAvailable() ? .camera : .gallery
        let picker = Picker(source: imageSource,
                            presentationStyle: .fullscreen,
                            allowsEditing: false,
                            delegate: self,
                            presentingViewController: router.presentedView)
        imageSelecter.pickImage(from: picker)
    }
}

extension SelectPhotoViewModel: ImageSelecterDelegate {
    
    func didSelectImage(image: UIImage) {
        photo.value = image
        
        isTakePhotoButtonVisibile.value = false
        progressBarProgress.value = 0.0
        isProgressBarVisibile.value = true
        shouldAnimateActivityIndicator.value = true
        
        let interactor = ImageTaggerInteractor(image: image, network: network)
        
        interactor
            .uploadImage { progress in
                self.progressBarProgress.value = progress
        }
        .then(interactor.fetchTagsAndColors)
        .then { (response) in
                let tags = response.0
                let colors = response.1
                
                self.isTakePhotoButtonVisibile.value = true
                self.isProgressBarVisibile.value = false
                self.shouldAnimateActivityIndicator.value = false
                
                // TODO: - Route to TagsView
        }
    }
}
