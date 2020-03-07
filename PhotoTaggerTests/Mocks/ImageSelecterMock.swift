//
//  ImageSelecterMock.swift
//  PhotoTaggerTests
//
//  Created by Ahmed Ramy on 3/7/20.
//  Copyright © 2020 Razeware LLC. All rights reserved.
//

import UIKit.UIImage
@testable import PhotoTagger

class ImageSelecterMock: ImageSelecterProtocol {
    
    var expectedImage: UIImage?
    var delegate: ImageSelecterDelegate?
    
    func pickImage(from picker: Picker) {
        picker.delegate.didSelectImage(image: expectedImage!)
        self.delegate?.didSelectImage(image: expectedImage!)
    }
}
