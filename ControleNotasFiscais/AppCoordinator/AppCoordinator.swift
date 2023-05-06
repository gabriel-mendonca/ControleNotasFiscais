//
//  AppCoordinator.swift
//  ControleNotasFiscais
//
//  Created by Gabriel Mendonça on 03/05/23.
//

import UIKit


final class AppCoordinator {
    
    private let window: UIWindow!
    private let navigation: UINavigationController!
    
    private var loginCoordinator: NSLoginCoordinator!
    
    required init(window: UIWindow) {
        self.window = window
        self.navigation = UINavigationController()
        self.window.rootViewController = navigation
        self.window.makeKeyAndVisible()
    }
    
    
    func start() {
        loginCoordinator = NSLoginCoordinator()
        loginCoordinator.start(usingPresentation: .push(navigationController: navigation), animated: true)
    }
}
