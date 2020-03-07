//
//  NetworkMock.swift
//  PhotoTaggerTests
//
//  Created by Ahmed Ramy on 3/7/20.
//  Copyright © 2020 Razeware LLC. All rights reserved.
//

import Moya
import Promises

@testable import PhotoTagger

class NetworkMock: NetworkProtocol {
    func call<U: TargetType, T: Codable>(api: U, model: T.Type) -> Promise<T> {
        return Promise<T>(on: .main) { fulfill, reject in
            if let object = self.objectsChain?.removeFirst() as? T {
                fulfill(object)
            } else if let object = self.object as? T {
                fulfill(object)
            } else if let error = self.error {
                reject(error)
            }
        }
    }
    
    func callAPIWithProgress<U: TargetType, T: Codable>(api: U, model: T.Type, _ progress: @escaping (Double) -> Void) -> Promise<T> {
        return Promise<T>(on: .main) { fulfill, reject in
            if let error = self.error {
                reject(error)
            } else if let object = self.objectsChain?.removeFirst() as? T {
                progress(1.0)
                fulfill(object)
            } else if let object = self.object as? T {
                (1...10).forEach {
                    progress(Double($0) / 10)
                }
                fulfill(object)
            }
        }
    }
    
    var object: Codable?
    var objectsChain: [Codable]?
    var error: Error?
}
