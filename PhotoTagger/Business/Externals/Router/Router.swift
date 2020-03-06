//
//  Router.swift
//
//  Created by Ahmed Meguid on 12/5/18.
//  Copyright © 2018 Ahmed Meguid. All rights reserved.
//

import UIKit
import ARSLineProgress

typealias AlertAction = (title: String, style: UIAlertAction.Style, action: () -> Void)

protocol Routable {
    var router: RouterProtocol { get }
}

extension Routable where Self: UIViewController {
    var router: RouterProtocol {
        let router = Router()
        router.presentedView = self as UIViewController
        return router
    }
}

class Router: RouterProtocol {
    
    var presentedView: UIViewController!
    
    func present(view: UIViewController) {
        presentedView.present(view, animated: true, completion: nil)
    }
    
    func startActivityIndicator() {
        ARSLineProgress.show()
    }
    
    func stopActivityIndicator() {
        ARSLineProgress.hide()
    }
    
    func dismiss() {
        presentedView.dismiss(animated: true, completion: nil)
    }
    
    func pop() {
        _ = presentedView.navigationController?.popViewController(animated: true)
    }
    
    func popToRoot() {
        _ = presentedView.navigationController?.popToRootViewController(animated: true)
    }
    
    func popTo(vc: UIViewController) {
        _ = presentedView.navigationController?.popToViewController(vc, animated: true)
    }
    
    func push(view: UIViewController) {
        presentedView
            .navigationController?
            .pushViewController(view, animated: true)
    }
    
    func alert(title: String, message: String, actions: [(title: String, style: UIAlertAction.Style)]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions
            .map {
                UIAlertAction(title: $0.title, style: $0.style, handler: nil)
            }
            .forEach {
                alert.addAction($0)
            }
        presentedView.present(alert, animated: true)
    }
    
    func alertWithAction(title: String,
                         message: String,
                         alertStyle: UIAlertController.Style,
                         actions: [AlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        actions.map { action in
                UIAlertAction(title: action.title, style: action.style, handler: { (_) in
                    action.action()
                })
            }.forEach {
                alert.addAction($0)
            }
        presentedView.present(alert, animated: true)
    }
    
    fileprivate func switchTabBarViewController(tabBarController: UITabBarController, tabIndex: MainTabbarController.TabBarScene) {
        tabBarController.selectedIndex = tabIndex.rawValue
        presentedView = tabBarController.selectedViewController
    }
    
    func switchTabBar(to tabIndex: MainTabbarController.TabBarScene) {
        if let tabBarController = presentedView as? MainTabbarController {
            switchTabBarViewController(tabBarController: tabBarController, tabIndex: tabIndex)
        } else if let tabBarController = presentedView.tabBarController {
            switchTabBarViewController(tabBarController: tabBarController, tabIndex: tabIndex)
        } else {
            assertionFailure("Couldn't switchh to \(tabIndex)")
        }
    }
}
