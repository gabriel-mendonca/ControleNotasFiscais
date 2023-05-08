//
//  NSForgetPasswordCoordinator.swift
//  ControleNotasFiscais
//
//  Created by Gabriel Mendonça on 06/05/23.
//

import UIKit

class NSForgetPasswordCoordinator: Coordinator {
    
    var view: NSForgetPasswordViewController?
    var navigation: NSNavigationViewController?
    var presentationType: PresentationType?
    
    init() {
        let viewModel = NSForgetPasswordViewModel()
        view = NSForgetPasswordViewController(viewModel: viewModel)
    }
    
    func stop() {
        view = nil
        navigation = nil
        presentationType = nil
    }
    
}
