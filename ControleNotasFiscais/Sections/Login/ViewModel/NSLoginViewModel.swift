//
//  NSLoginViewModel.swift
//  ControleNotasFiscais
//
//  Created by Gabriel Mendonça on 05/05/23.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import FirebaseFirestore

protocol NSLoginViewModelCoordinatorDelegate: AnyObject {
    func goToForgetPassword()
}


class NSLoginViewModel {
    
    var model: LoginUserModel?
    private let auth: Auth!
    private let firestore: Firestore!
    weak var delegate: NSLoginViewModelCoordinatorDelegate?
    
    init() {
        auth = Auth.auth()
        firestore = Firestore.firestore()
    }
    
    func getUSerFromApi (_ email :String,_ password: String, completion: @escaping (Result<LoginUserModel, Error>) -> Void) {
        let manager = UserManager(business: UserBusiness())
        manager.login(email: email, password: password) { userModel in
            completion(.success(userModel))
        } failureHandler: { error in
            completion(.failure(error))
            
        }
    }
    
    func registerNewUser(_ nome: String, _ email : String,_ password: String, completion: @escaping (NSDictionary) -> Void) {
        var resultReturn:NSDictionary = [:]
        guard nome != "" && email != "" && password != "" else {
            completion(["result":"error", "message_error":"invalidFields"])
            return
        }
        
        auth.createUser(withEmail: email, password: password) { (result, error) in
            
            if error == nil {
                if let idResultado = result?.user.uid {
                    self.firestore.collection("usuarios").document(idResultado).setData(["nome": nome, "email": email])
                }
                resultReturn = ["result":"success", "message_error":""]
                do {
                    try self.auth.signOut() }
                catch {
                    print("erro ao deslogar usuario")
                    
                }
                
            } else {
                resultReturn = ["result":"error", "message_error": error?.localizedDescription ?? "Erro ao cadastrar usuario"]
                
            }
            completion(resultReturn)
        }
    }
    
    func goForgetPassword() {
        delegate?.goToForgetPassword()
    }
}
