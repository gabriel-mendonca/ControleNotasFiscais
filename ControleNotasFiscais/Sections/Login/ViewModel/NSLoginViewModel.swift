//
//  NSLoginViewModel.swift
//  ControleNotasFiscais
//
//  Created by Gabriel Mendonça on 05/05/23.
//

import Foundation

protocol NSLoginViewModelCoordinatorDelegate: AnyObject {
    func goToForgetPassword()
}


class NSLoginViewModel {
    
    weak var delegate: NSLoginViewModelCoordinatorDelegate?
    
    func goForgetPassword() {
        delegate?.goToForgetPassword()
    }
}
