//
//  MoyaManager.swift
//  camelan
//
//  Created by Ahmed Ramy on 1/30/20.
//  Copyright © 2020 Camelan . All rights reserved.
//

import Moya
import Promises

class MoyaManager: NetworkProtocol {
    func callAPIWithProgress<U: TargetType, T: Codable>(
    api: U,
    model: T.Type,
    _ progress: @escaping (Double) -> Void) -> Promise<T> {
        return Promise<T> { fullfil, reject in
            let provider = MoyaProvider<U>()
            provider.request(api, callbackQueue: nil, progress: { (response) in
                progress(response.progress)
            }) { (result) in
                switch result {
                case .success(let response):
                    do {
                        let model = try response.map(T.self)
                        fullfil(model)
                    } catch {
                        reject(error)
                    }
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    func call<U: TargetType, T: Codable>(api: U, model: T.Type) -> Promise<T> {
        return Promise<T> { fullfil, reject in
            let provider = MoyaProvider<U>()
            provider.request(api) { (result) in
                switch result {
                case .success(let response):
                    do {
                        let model = try response.map(T.self)
                        fullfil(model)
                    } catch let error {
                        reject(error)
                    }
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }
}
