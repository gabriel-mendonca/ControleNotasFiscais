//
//  NSForgetPasswordViewController.swift
//  ControleNotasFiscais
//
//  Created by Gabriel Mendonça on 06/05/23.
//

import UIKit

class NSForgetPasswordViewController: UIViewController {
    
    let viewModel: NSForgetPasswordViewModel!
    
    init(viewModel: NSForgetPasswordViewModel) {
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
    
    lazy var textFieldEmail: NSTextField = {
        let textField = NSTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 5
        textField.placeholder = "Digite seu email aqui"
        textField.textPadding = 10
        return textField
    }()
    
    lazy var buttonSendEmail: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Enviar Email", for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        return button
    }()
    
    private func constraintsTextFieldEmail() {
        textFieldEmail.anchorCenterSuperview()
        textFieldEmail.anchor(left: view.leftAnchor,
                              right: view.rightAnchor,
                              leftConstant: 24,
                              rightConstant: 24,
                              heightConstant: 40)
    }
    
    private func constraintsButtonSendEmail() {
        buttonSendEmail.anchor(top: textFieldEmail.bottomAnchor,
                               left: view.leftAnchor,
                               right: view.rightAnchor,
                               topConstant: 24,
                               leftConstant: 24,
                               rightConstant: 24,
                               heightConstant: 50)
    }
    
    
    
}

extension NSForgetPasswordViewController: ViewLayoutHelper {
    func buildViewHierarchy() {
        view.addSubview(textFieldEmail)
        view.addSubview(buttonSendEmail)
    }
    
    func setupContraints() {
        constraintsTextFieldEmail()
        constraintsButtonSendEmail()
    }
    
    func setupAdditionalConfiguration() {
        title = "Esqueci minha senha"
        view.backgroundColor = .black
    }
    
    
}
