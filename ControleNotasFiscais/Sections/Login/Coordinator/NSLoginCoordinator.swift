//
//  NSLoginCoordinator.swift
//  ControleNotasFiscais
//
//  Created by Gabriel Mendonça on 03/05/23.
//

import UIKit

class NSLoginCoordinator: Coordinator {
    var view: NSLoginViewController?
    var navigation: UINavigationController?
    var presentationType: PresentationType?
    
    func start() -> NSLoginViewController {
        let viewModel = NSLoginViewModel()
        view = NSLoginViewController(viewModel: viewModel)
        return view!
    }
    
    func stop() {
   
    }
}
