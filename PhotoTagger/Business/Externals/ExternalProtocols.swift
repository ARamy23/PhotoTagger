//
//  ExternalProtocols.swift
//
//  Created by Ahmed Ramy on 12/4/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import UIKit
import Moya
import Promises

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
}

protocol NetworkProtocol {
  func call<U: TargetType, T: Codable>(api: U, model: T.Type) -> Promise<T>
    func callAPIWithProgress<U: TargetType, T: Codable>(
        api: U,
        model: T.Type,
        _ progress: @escaping (Double) -> Void) -> Promise<T>
}

protocol SystemProtocol {
    func isCameraAvailable() -> Bool
}
