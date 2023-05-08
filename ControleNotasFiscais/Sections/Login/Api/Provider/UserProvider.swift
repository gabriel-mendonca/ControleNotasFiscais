//
//  UserProvider.swift
//  ControleNotasFiscais
//
//  Created by Gabriel Mendonça on 06/05/23.
//

import Foundation
import UIKit
import FirebaseAuth

protocol UserProviderProtocol {
    func login(parameters: [AnyHashable:Any], completionHandler:
               @escaping(Result<LoginUserModel,Error>) -> Void)
    
    func register(parameters: [AnyHashable:Any], completionHandler:
            @escaping(Result<LoginUserModel,Error>) -> Void)
}


class UserProvider : UserProviderProtocol {
    lazy var auth = Auth.auth()
    
    func login(parameters: [AnyHashable : Any], completionHandler: @escaping (Result<LoginUserModel, Error>) -> Void) {
        let body: NSDictionary = parameters[Constants.ParametersKeys.body] as! NSDictionary
        let userModel = body[Constants.ParametersKeys.userModel] as! LoginUserModel

        self.auth.signIn(withEmail: userModel.email, password: userModel.password) { (result,error) in
            if let error = error {
                completionHandler(.failure(error as! Error))
                
            } else {
                completionHandler(.success(userModel))
            }
            
        }
    
    }
    
    func register(parameters: [AnyHashable : Any], completionHandler: @escaping (Result<LoginUserModel, Error>) -> Void) {
        let body: NSDictionary = parameters[Constants.ParametersKeys.body] as! NSDictionary
        let userModel = body[Constants.ParametersKeys.userModel] as! LoginUserModel
        
        self.auth.createUser(withEmail: userModel.email, password: userModel.password) { (result,error) in
            if let error = error {
                completionHandler(.failure(error as! Error))
            } else {
                completionHandler(.success(userModel))
            }
            
        }
    }
    
    
}
