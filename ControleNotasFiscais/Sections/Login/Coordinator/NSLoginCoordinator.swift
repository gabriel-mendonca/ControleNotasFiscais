//
//  NSLoginCoordinator.swift
//  ControleNotasFiscais
//
//  Created by Gabriel Mendonça on 03/05/23.
//

import UIKit

class NSLoginCoordinator: Coordinator {
    var view: NSLoginViewController?
    var navigation: NSNavigationViewController?
    var presentationType: PresentationType?
    
    var nsForgetPasswordCoordinator: NSForgetPasswordCoordinator!
    
    func start() -> NSLoginViewController {
        let viewModel = NSLoginViewModel()
        viewModel.delegate = self
        view = NSLoginViewController(viewModel: viewModel)
        return view!
    }
    
    func stop() {
        view = nil
        navigation = nil
        presentationType = nil
    }
}

extension NSLoginCoordinator: NSLoginViewModelCoordinatorDelegate {
    func goToForgetPassword() {
        guard let navigation = navigation else { return }
        nsForgetPasswordCoordinator = NSForgetPasswordCoordinator()
        nsForgetPasswordCoordinator.start(usingPresentation: .push(navigationController: navigation), animated: true)
    }
    
    
}
