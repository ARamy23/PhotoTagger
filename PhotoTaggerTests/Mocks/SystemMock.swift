//
//  SystemMock.swift
//  PhotoTaggerTests
//
//  Created by Ahmed Ramy on 3/7/20.
//  Copyright © 2020 Razeware LLC. All rights reserved.
//

import Foundation
@testable import PhotoTagger

class SystemMock: SystemProtocol {
    var shouldCameraBeAvaialbe: Bool = true
    
    func isCameraAvailable() -> Bool {
        return shouldCameraBeAvaialbe
    }
}
