//
//  NSLoginViewController.swift
//  ControleNotasFiscais
//
//  Created by Gabriel Mendonça on 03/05/23.
//

import UIKit
import GoogleSignIn
import Firebase

class NSLoginViewController: UIViewController {
    
    private let viewModel: NSLoginViewModel!
    
    init(viewModel: NSLoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    lazy var titlePage: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Controle Nota fiscal"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = .white
        return label
    }()
    
    lazy var stackButtonsLogin: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.spacing = 12
        return stack
    }()
    
    lazy var textFieldEmail: NSTextField = {
        let text = NSTextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .white
        text.clipsToBounds = true
        text.layer.cornerRadius = 5
        text.placeholder = "Digite seu email"
        text.textPadding = 10
        return text
    }()
    
    lazy var textFieldPassword: NSTextField = {
        let password = NSTextField()
        password.translatesAutoresizingMaskIntoConstraints = false
        password.backgroundColor = .white
        password.clipsToBounds = true
        password.layer.cornerRadius = 5
        password.placeholder = "Password"
        password.isSecureTextEntry = true
        password.rightImage = UIImage(systemName: "eye.slash.fill")!
        password.actionButtonImage = {
            if password.isSelectedButton {
                password.rightImage = UIImage(systemName: "eye.slash.fill")!
                password.isSecureTextEntry = password.isSelectedButton
            } else {
                password.rightImage = UIImage(systemName: "eye.fill")!
                password.isSecureTextEntry = password.isSelectedButton
            }
        }
        password.textPadding = 10
        return password
    }()
    
    lazy var buttonForgetPassword: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Esqueci minha senha", for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(sendToForgetPassword), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonEnter: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Entrar", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        button.backgroundColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(validateSignIn), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonCadastrar: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cadastrar", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        button.backgroundColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        return button
    }()
    
    lazy var buttonGoogle: GIDSignInButton = {
        let button = GIDSignInButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        button.backgroundColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(signGoogle), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonFacebook: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login com Facebook", for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        return button
    }()
    
    private func validate() {
        
        guard textFieldEmail.text != "" else {
            showMessage("Atenção", "Preencha o campo EMAIL!")
            return
        }
        guard (textFieldEmail.text ?? "").isEmailValido() else {
            showMessage("Atencao", "Digite um email valido!")
            return
        }
        
        guard textFieldPassword.text != "" else {
            showMessage("Atenção", "Preencha o campo PASSWORD!")
            return
        }
    }
    
    @objc
    private func signGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
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
                    
                    self.viewModel.registerNewUser(name, email, "") { data in
                        if let result:String = data["result"] as? String,
                           let messageError:String = data["message_error"] as? String {
                            if result == "error" {
                                self.showMessage("Erro", messageError)
                            } else if result == "success" {
                                //gohome
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                    self.showMessageOnTimer("Sucesso", "Usuario Cadastrado.")
                                }
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    @objc
    private func sendToForgetPassword() {
        viewModel.goForgetPassword()
    }
    
    @objc
    private func validateSignIn() {
        let email = textFieldEmail.text ?? ""
        let password = textFieldPassword.text ?? ""
        
        viewModel.getUSerFromApi(email, password) {[weak self] result in
            switch result {
                
            case .success(_):
                self?.validate()
                    
                
            case .failure(let error):
                if error.localizedDescription.contains("Access to this account has") == true {
                    self?.showMessage("Atençao !", "O acesso a conta foi temporariamente bloqueado devido a diversas tentativas com senha incorreta. Para acesso imediato reset sua senha, ou tente novamente mais tarde.")
                } else if error.localizedDescription == "The password is invalid or the user does not have a password." {
                    self?.showMessage("Atençao !", "Senha invalida, verifique!")
                } else {
                    self?.validate()
                }
            }
        }

    }
    
    private func constraintsTitlePage() {
        titlePage.anchor(top: view.topAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         topConstant: 200,
                         leftConstant: 16,
                         rightConstant: 16)
    }
    
    private func constraintStackFieldButtonsLogin() {
        stackButtonsLogin.anchor(left: view.leftAnchor,
                                 bottom: view.bottomAnchor,
                                 right: view.rightAnchor,
                                 leftConstant: 24,
                                 bottomConstant: 50,
                                 rightConstant: 24,
                                 heightConstant: 150)
    }
    
    private func constraintsTextFieldEmail() {
        textFieldEmail.anchor(top: titlePage.bottomAnchor,
                              left: view.leftAnchor,
                              right: view.rightAnchor,
                              topConstant: 100,
                              leftConstant: 24,
                              rightConstant: 24,
                              heightConstant: 40)
    }
    
    private func constraintsTextFieldPassword() {
        textFieldPassword.anchor(top: textFieldEmail.bottomAnchor,
                                 left: view.leftAnchor,
                                 right: view.rightAnchor,
                                 topConstant: 12,
                                 leftConstant: 24,
                                 rightConstant: 24,
                                 heightConstant: 40)
    }
    
    private func constraintsButtonForgetPassword() {
        buttonForgetPassword.anchor(top: textFieldPassword.bottomAnchor,
                                    right: view.rightAnchor,
                                    topConstant: 12,
                                    rightConstant: 24,
                                    widthConstant: 180,
                                    heightConstant: 16)
    }
    
    private func constraintsButtonEnter() {
        buttonEnter.anchor(top: textFieldPassword.bottomAnchor,
                           left: view.leftAnchor,
                           right: view.rightAnchor,
                           topConstant: 50,
                           leftConstant: 24,
                           rightConstant: 24,
                           heightConstant: 50)
    }
}

extension NSLoginViewController: ViewLayoutHelper {
    func buildViewHierarchy() {
        view.addSubview(titlePage)
        view.addSubview(textFieldEmail)
        view.addSubview(textFieldPassword)
        view.addSubview(buttonForgetPassword)
        view.addSubview(buttonEnter)
        view.addSubview(stackButtonsLogin)
        
        stackButtonsLogin.addArrangedSubview(buttonCadastrar)
        stackButtonsLogin.addArrangedSubview(buttonGoogle)
        stackButtonsLogin.addArrangedSubview(buttonFacebook)
    }
    
    func setupContraints() {
        constraintsTitlePage()
        constraintsTextFieldEmail()
        constraintsTextFieldPassword()
        constraintsButtonForgetPassword()
        constraintStackFieldButtonsLogin()
        constraintsButtonEnter()
    }
    
    func setupAdditionalConfiguration() {
        view.backgroundColor = .black
    }
    
    
}
