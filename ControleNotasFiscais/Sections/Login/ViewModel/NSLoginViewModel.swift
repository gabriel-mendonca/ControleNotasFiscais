//
//  NSLoginViewModel.swift
//  ControleNotasFiscais
//
//  Created by Gabriel Mendonça on 05/05/23.
//

import Foundation
import GoogleSignIn
import Firebase
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit
import CryptoKit

protocol NSLoginViewModelCoordinatorDelegate: AnyObject {
    func goToForgetPassword()
}


class NSLoginViewModel {
    
    var model: LoginUserModel?
    var currentNonce: String?
    private let auth: Auth!
    private let firestore: Firestore!
    private let loginManager: LoginManager!
    weak var delegate: NSLoginViewModelCoordinatorDelegate?
    
    init() {
        loginManager = LoginManager()
        auth = Auth.auth()
        firestore = Firestore.firestore()
        currentNonce = randomNonceString()
    }
    
    func getUSerFromApi(_ email :String,_ password: String, completion: @escaping (Result<LoginUserModel, Error>) -> Void) {
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
    
    func signIn(email: String, password: String, viewController: UIViewController) {
        getUSerFromApi(email, password) {[weak self] result in
            guard let self = self else { return }
            switch result {
                
            case .success(_):
                self.validate(email: email,
                                         password: password,
                                         viewController: viewController)
                    
                
            case .failure(let error):
                if error.localizedDescription.contains("Access to this account has") == true {
                    viewController.showMessage("Atençao !", "O acesso a conta foi temporariamente bloqueado devido a diversas tentativas com senha incorreta. Para acesso imediato reset sua senha, ou tente novamente mais tarde.")
                } else if error.localizedDescription == "The password is invalid or the user does not have a password." {
                    viewController.showMessage("Atençao !", "Senha invalida, verifique!")
                } else {
                    self.validate(email: email,
                                             password: password,
                                             viewController: viewController)
                }
            }
        }
    }
    
    func signInGoogle(_ viewController: UIViewController) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
            guard error == nil else { return }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { authResult, error in
                if error != nil {
                    return
                }
                
                if let profileData = authResult {
                    let email: String = profileData.user.email ?? ""
                    let name: String = profileData.user.displayName ?? ""
                    
                    self.registerNewUser(name, email, "") { data in
                        if let result:String = data["result"] as? String,
                           let messageError:String = data["message_error"] as? String {
                            if result == "error" {
                                viewController.showMessage("Erro", messageError)
                            } else if result == "success" {
                                //gohome
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                    viewController.showMessageOnTimer("Sucesso", "Usuario Cadastrado.")
                                }
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    func logoutFacebook() {
            loginManager.logOut()
        do{
            try Auth.auth().signOut()
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    func signInFacebook(_ viewController: UIViewController) {
        loginManager.logIn(permissions: ["email","public_profile"], from: viewController) { [weak self] (result, error) in
            if let error = error {
                print("Erro ao efetuar login com o Facebook: \(error.localizedDescription)")
            } else if let result = result, result.isCancelled {
                print("Cancelled")
            } else {
                print("Logged In")
            }
    
            guard let accessToken = AccessToken.current?.tokenString else {
                   print("Erro ao recuperar o token de acesso do Facebook.")
                   return
               }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
               Auth.auth().signIn(with: credential) { (authResult, error) in
                   if let error = error {
                       print("Erro ao efetuar login com o Firebase: \(error.localizedDescription)")
                       return
                   }
                   
                   if let profileData = authResult {
                       let email: String = profileData.user.email ?? ""
                       let name: String = profileData.user.displayName ?? ""
                       
                       self?.registerNewUser(name, email, "") { data in
                           if let result:String = data["result"] as? String,
                              let messageError:String = data["message_error"] as? String {
                               if result == "error" {
                                   viewController.showMessage("Erro", messageError)
                               } else if result == "success" {
                                   if let token = AccessToken.current,
                                           !token.isExpired {
                                           print("facebook conectado")
                                       //gohome
                                       }
                                   //gohome
                                   DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                       viewController.showMessageOnTimer("Sucesso", "Usuario Cadastrado.")
                                   }
                               }
                           }
                       }
                   }
               }
           }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }
    
    func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }

    
    func validate(email: String?, password: String?, viewController: UIViewController) {
        
        guard email != "" else {
            viewController.showMessage("Atenção", "Preencha o campo EMAIL!")
            return
        }
        guard (email ?? "").isEmailValido() else {
            viewController.showMessage("Atencao", "Digite um email valido!")
            return
        }
        
        guard password != "" else {
            viewController.showMessage("Atenção", "Preencha o campo PASSWORD!")
            return
        }
    }
    
    func goForgetPassword() {
        delegate?.goToForgetPassword()
    }
}
