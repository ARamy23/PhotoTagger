//
//  SelectPhotoTests.swift
//  PhotoTaggerTests
//
//  Created by Ahmed Ramy on 3/7/20.
//  Copyright © 2020 Razeware LLC. All rights reserved.
//

import XCTest
@testable import Promises
@testable import PhotoTagger

class SelectPhotoTests: BaseSceneTests {

    var sut: SelectPhotoViewModel!
    
    override func setUp() {
        super.setUp()
        sut = SelectPhotoViewModel(network: network,
                                   system: system,
                                   imageSelecter: imageSelecter,
                                   router: router)
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func testThatWhenCameraIsAvailableAndViewDidLoadTakePictureButtonTitleIsTakePhoto() {
        // Given
        system.shouldCameraBeAvaialbe = true
        
        // When
        sut.viewDidLoad()
        
        // Then
        XCTAssertEqual(sut.takePhotoButtonTitle.value!, "Take Photo")
    }
    
    func testThatWhenCameraIsNotAvailableAndViewDidLoadTakePictureButtonTitleIsSelectPhoto() {
        // Given
        system.shouldCameraBeAvaialbe = false
        
        // When
        sut.viewDidLoad()
        
        // Then
        XCTAssertEqual(sut.takePhotoButtonTitle.value!, "Select Photo")
    }
    
    func testWhenTakePictureButtonIsPressedAnImageIsSelectedFromCameraWhenItIsAvaialble() {
        // Given
        system.shouldCameraBeAvaialbe = true
        let expectedImage = #imageLiteral(resourceName: "Blog Logo")
        imageSelecter.expectedImage = expectedImage
        
        // When
        sut.takePicture()
        
        // Then
        XCTAssertEqual(expectedImage, imageSelecterDelegate.returnedImage!)
    }
    
    func testWhenTakePictureButtonIsPressedAnImageIsSelectedFromGalleryWhenItIsAvailable() {
        // Given
        system.shouldCameraBeAvaialbe = false
        let expectedImage = #imageLiteral(resourceName: "Blog Logo")
        imageSelecter.expectedImage = expectedImage
        
        // When
        sut.takePicture()
        
        // Then
        XCTAssertEqual(expectedImage, imageSelecterDelegate.returnedImage!)
    }
    
    func testWhenPictureIsTakenTakePhotoButtonIsHiddenAndProgressShowsUpAndLoaderSpins() {
        // Given
        system.shouldCameraBeAvaialbe = false
        let expectedImage = #imageLiteral(resourceName: "Blog Logo")
        imageSelecter.expectedImage = expectedImage
        network.objectsChain = ["contentID", ["Tag"], [PhotoColor()]]
        
        // When
        sut.takePicture()
        
        // Then
        XCTAssert(sut.isTakePhotoButtonVisibile.value == false)
        XCTAssert(sut.progressBarProgress.value == 0.0)
        XCTAssert(sut.shouldAnimateActivityIndicator.value == true)
        XCTAssert(sut.isProgressBarVisibile.value == true)
        
        _ = waitForPromises(timeout: 1)
        _ = waitForPromises(timeout: 1)
        
        XCTAssert(sut.isTakePhotoButtonVisibile.value == true)
        XCTAssert(sut.progressBarProgress.value == 1.0)
        XCTAssert(sut.shouldAnimateActivityIndicator.value == false)
        XCTAssert(sut.isProgressBarVisibile.value == false)
    }
}

class ImageSelecterDelegateFake: ImageSelecterDelegate {
    var returnedImage: UIImage?
    
    func didSelectImage(image: UIImage) {
        self.returnedImage = image
    }
}
