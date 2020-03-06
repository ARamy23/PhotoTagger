//
//  System.swift
//  PhotoTagger
//
//  Created by Ahmed Ramy on 3/6/20.
//  Copyright © 2020 Razeware LLC. All rights reserved.
//

import UIKit

struct SystemImp: SystemProtocol {
    func isCameraAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }
}
