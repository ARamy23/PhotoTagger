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
    let router: Router
    
    init(network: NetworkProtocol = MoyaManager(),
         system: SystemProtocol = SystemImp(),
         router: RouterProtocol) {
        self.network = network
        self.system = system
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
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        
        if system.isCameraAvailable() {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
            picker.modalPresentationStyle = .fullScreen
        }
        
        router.present(view: picker)
    }
}

extension SelectPhotoViewModel: UINavigationControllerDelegate { }

extension SelectPhotoViewModel: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            print("Info did not have the required UIImage for the Original Image")
            router.dismiss()
            return
        }
        
        photo.value = image
        
        isTakePhotoButtonVisibile.value = false
        progressBarProgress.value = 0.0
        isProgressBarVisibile.value = true
        shouldAnimateActivityIndicator.value = true
        
        let interactor = ImageTaggerInteractor(image: image, network: network)
        
        interactor
            .uploadImage { progress in
                self.progressBarProgress.value = progress
            }.then(interactor.fetchTagsAndColors)
            .then { (response) in
                let tags = response.0
                let colors = response.1
                
                self.isTakePhotoButtonVisibile.value = true
                self.isProgressBarVisibile.value = false
                self.shouldAnimateActivityIndicator.value = false
                
                // TODO: - Route to TagsView
            }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
