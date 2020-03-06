//
//  SelectPhotoViewModel.swift
//  PhotoTagger
//
//  Created by Ahmed Ramy on 3/6/20.
//  Copyright © 2020 Razeware LLC. All rights reserved.
//

import Foundation

class SelectPhotoViewModel {
    
    // MARK: Outputs
    var takePhotoButtonTitle = Dynamic<String>("")
    
    // MARK: Dependencies
    let network: NetworkProtocol
    let system: SystemProtocol
    
    init(network: NetworkProtocol = MoyaManager(), system: SystemProtocol = SystemImp()) {
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
}
