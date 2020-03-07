//
//  ImageSelecter.swift
//  PhotoTagger
//
//  Created by Ahmed Ramy on 3/7/20.
//  Copyright © 2020 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit

protocol ImageSelecterProtocol {
    func pickImage(from picker: Picker)
}

class ImageSelecter: NSObject, ImageSelecterProtocol {
    
    var delegate: ImageSelecterDelegate?
    
    var picker: Picker?
    
    let presentingView: UIViewController
    
    init(presentingView: UIViewController) {
        self.presentingView = presentingView
    }
    
    func pickImage(from picker: Picker) {
        self.picker = picker
        self.delegate = picker.delegate
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = picker.allowsEditing
        pickerController.sourceType = picker.source.iOSSourceType
        pickerController.modalPresentationStyle = picker.presentationStyle.iOSPresentationStyle
        
        
        presentingView.present(pickerController, animated: true)
    }
}

extension ImageSelecter: UINavigationControllerDelegate { }

extension ImageSelecter: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            print("Info did not have the required UIImage for the Original Image")
            picker.dismiss(animated: true)
            return
        }
        
        delegate?.didSelectImage(image: image)
    }
}

protocol ImageSelecterDelegate {
    func didSelectImage(image: UIImage)
}

struct Picker {
    let source: ImageSource
    let presentationStyle: PickerPresentationStyle
    let allowsEditing: Bool
    let delegate: ImageSelecterDelegate
}

enum ImageSource {
    case camera
    case gallery
    
    var iOSSourceType: UIImagePickerController.SourceType {
        switch self {
        case .camera: return .camera
        case .gallery: return .photoLibrary
        }
    }
}

enum PickerPresentationStyle {
    case fullscreen
    
    var iOSPresentationStyle: UIModalPresentationStyle {
        return .fullScreen
    }
}
