//
//  BaseSceneTests.swift
//  PhotoTaggerTests
//
//  Created by Ahmed Ramy on 3/7/20.
//  Copyright © 2020 Razeware LLC. All rights reserved.
//

import XCTest
@testable import PhotoTagger

class BaseSceneTests: XCTestCase {
    
    var router: RouterMock!
    var system: SystemMock!
    var imageSelecter: ImageSelecterMock!
    var network: NetworkMock!
    var imageSelecterDelegate: ImageSelecterDelegateFake!
    
    override func setUp() {
        super.setUp()
        self.router = RouterMock()
        self.system = SystemMock()
        self.imageSelecter = ImageSelecterMock()
        self.network = NetworkMock()
        self.imageSelecterDelegate = ImageSelecterDelegateFake()
        self.imageSelecter.delegate = imageSelecterDelegate
    }

    override func tearDown() {
        super.tearDown()
        self.router = nil
        self.system = nil
        self.imageSelecter = nil
        self.network = nil
        self.imageSelecterDelegate = nil
    }
}
