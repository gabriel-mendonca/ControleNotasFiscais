//
//  UserManager.swift
//  ControleNotasFiscais
//
//  Created by Gabriel Mendonça on 06/05/23.
//

import Foundation
import UIKit


protocol UserManagerProtocol {
    func login(email:String, password:String,
               successHandler: @escaping(LoginUserModel) ->Void,
               failureHandler:@escaping(Error) -> Void )
    func register(email:String, password:String,
               successHandler: @escaping(LoginUserModel) ->Void,
               failureHandler:@escaping(Error) -> Void )
}

class UserManager: UserManagerProtocol {
    let business: UserBusiness
    
    init(business: UserBusiness) {
        self.business = business
    }
    
    func login(email: String, password: String, successHandler: @escaping (LoginUserModel) -> Void, failureHandler: @escaping (Error) -> Void) {
        business.login(email: email, password: password ) { result in
            switch result {
                
            case .success(let userModel):
                successHandler(userModel)
            case .failure(let error):
                failureHandler(error)
            }
            
        }
    }
    
    func register(email: String, password: String, successHandler: @escaping (LoginUserModel) -> Void, failureHandler: @escaping (Error) -> Void) {
        business.register(email: email, password: password ) { result in
            switch result {
                
            case .success(let userModel):
                successHandler(userModel)
            case .failure(let error):
                failureHandler(error)
            }
        }
    }
    
    
}

