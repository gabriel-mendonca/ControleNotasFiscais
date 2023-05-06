//
//  NSLoginViewController.swift
//  ControleNotasFiscais
//
//  Created by Gabriel Mendonça on 03/05/23.
//

import UIKit

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
        password.textPadding = 10
        return password
    }()
    
    lazy var buttonForgetPassword: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Esqueci minha senha", for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    lazy var buttonCadastrar: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cadastrar", for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        return button
    }()
    
    lazy var buttonGoogle: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login com google", for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        return button
    }()
    
    lazy var buttonApple: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login com Apple", for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        return button
    }()
    
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
    
    private func constraintsButtonGoogle() {
        buttonGoogle.anchor(top: textFieldPassword.bottomAnchor,
                            left: view.leftAnchor,
                            right: view.rightAnchor,
                            topConstant: 12,
                            leftConstant: 16,
                            rightConstant: 16,
                            heightConstant: 12)
    }
    
    private func constraintsButtonApple() {
        buttonGoogle.anchor(top: buttonGoogle.bottomAnchor,
                            left: view.leftAnchor,
                            right: view.rightAnchor,
                            topConstant: 12,
                            leftConstant: 16,
                            rightConstant: 16,
                            heightConstant: 12)
    }
}

extension NSLoginViewController: ViewLayoutHelper {
    func buildViewHierarchy() {
        view.addSubview(titlePage)
        view.addSubview(textFieldEmail)
        view.addSubview(textFieldPassword)
        view.addSubview(buttonForgetPassword)
        view.addSubview(stackButtonsLogin)
        
        stackButtonsLogin.addArrangedSubview(buttonCadastrar)
        stackButtonsLogin.addArrangedSubview(buttonGoogle)
        stackButtonsLogin.addArrangedSubview(buttonApple)
    }
    
    func setupContraints() {
        constraintsTitlePage()
        constraintsTextFieldEmail()
        constraintsTextFieldPassword()
        constraintsButtonForgetPassword()
        constraintStackFieldButtonsLogin()
    }
    
    func setupAdditionalConfiguration() {
        view.backgroundColor = .black
    }
    
    
}
