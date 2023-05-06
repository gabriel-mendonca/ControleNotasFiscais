//
//  Coordinator.swift
//  ControleNotasFiscais
//
//  Created by Gabriel Mendonça on 03/05/23.
//

import UIKit

enum PresentationType {
    case push(navigationController: UINavigationController)
    case modal(viewController: UIViewController)
    
    func associatedValue() -> Any? {
        switch self {
        case .push(let value):
            return value
        case .modal(let value):
            value.modalPresentationStyle = .fullScreen
            return value
        }
    }
}

protocol Coordinator: AnyObject {
    associatedtype V: UIViewController
    var view: V? { get set }
    var navigation: UINavigationController? { get set }
    var presentationType: PresentationType? { get set }
    
    func start() -> V
    
    func start(usingPresentation presentation: PresentationType, animated: Bool)
    
    func stop()
}

extension Coordinator {
    func start() -> V {
        if view == nil {
            fatalError("you cannot start coordinator without initalize property view!")
        }
        return self.view!
    }
    
    func start(usingPresentation presentation: PresentationType, animated: Bool) {
        switch presentation {
        case .push(let navigation):
            self.navigation = navigation
            navigation.pushViewController(start(), animated: animated)
        case .modal(let controller):
            self.navigation = UINavigationController(rootViewController: start())
            guard let nav = self.navigation else { return }
            controller.present(nav, animated: animated, completion: nil)
        }
    }
}
