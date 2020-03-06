//
//  ExternalProtocols.swift
//
//  Created by Ahmed Ramy on 12/4/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import UIKit
import Moya
import Mapper
import Promises

protocol CacheProtocol {
    func getData(key: CachingKey) -> [Data]?
    func saveData(_ data: Data, key: CachingKey)
    func getObject<T: Codable>(_ object: T.Type, key: CachingKey) -> T?
    func saveObject<T: Codable>(_ object: T, key: CachingKey)
    func removeObject(key: CachingKey)
}

protocol RouterProtocol {
    var presentedView: UIViewController! { set get }
    func present(view: UIViewController)
    func startActivityIndicator()
    func stopActivityIndicator()
    func dismiss()
    func pop()
    func popToRoot()
    func popTo(vc: UIViewController)
    func push(view: UIViewController)
    func alert(title: String, message: String, actions: [(title: String, style: UIAlertAction.Style)])
    func alertWithAction(title: String, message: String, alertStyle: UIAlertController.Style, actions: [AlertAction])
    func switchTabBar(to tabIndex: MainTabbarController.TabBarScene)
    func alertWithGenericError()
}

extension RouterProtocol {
    func alertWithGenericError() {
        alert(title: "Error",
              message: ValidationError.genericError.localizedDescription,
              actions: [(title: "Ok", style: .default)])
    }
}

protocol NetworkProtocol {
    func call<U: TargetType, T: Codable>(api: U, model: T.Type) -> Promise<T>
    func callEmptyResponse<U: TargetType>(api: U, _ onFetch: @escaping (Result<Void, Error>) -> Void)
    func call<T: Codable, U: TargetType>(api: U, model: T.Type, _ onFetch: @escaping (Result<T, Error>) -> Void)
    func call<T: Mappable, U: TargetType>(api: U, model: T.Type, _ onFetch: @escaping (Result<T, Error>) -> Void)
    func call<T: Mappable, U: TargetType>(api: U, model: [T].Type, _ onFetch: @escaping (Result<[T], Error>) -> Void)
    
    func call<U: TargetType>(api: U, _ onFetch: @escaping (Result<Response, Error>) -> Void)
}

