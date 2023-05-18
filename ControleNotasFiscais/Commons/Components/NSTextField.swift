//
//  TextField+Extension.swift
//  ControleNotasFiscais
//
//  Created by Gabriel Mendonça on 05/05/23.
//

import UIKit

class NSTextField: UITextField, UITextFieldDelegate {
    var edge: UIEdgeInsets!
    var actionButtonImage: () -> Void = {}
    var isSelectedButton: Bool = true
    
    var rightImage: UIImage = UIImage() {
        didSet {
            addRightButton(withImage: rightImage)
        }
    }
    
    var textPadding: CGFloat = 0 {
        didSet {
            setLeftEdgeInsetsPadding(left: textPadding)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
       
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
       
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: edge)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: edge)
    }
    
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        return true
//    }
//
    func addRightButton(withImage image: UIImage) {
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        self.rightView = button
        self.rightViewMode = .always
    }
    
    @objc private func rightButtonTapped() {
        isSelectedButton = !isSelectedButton
        actionButtonImage()
    }
    
    func setLeftEdgeInsetsPadding(left: CGFloat) {
        self.edge = UIEdgeInsets(top: 0, left: left, bottom: 0, right: 0)
    }
//
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        return beginEditing()
//    }
//
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        return endEditing()
//    }
//
//    private func beginEditing() -> Bool {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        return true
//    }
//
//    private func endEditing() -> Bool {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//        return true
//    }
//
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
//
//    @objc private func keyboardWillShow(_ notification: Notification) {
//        guard let userInfo = notification.userInfo,
//              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
//            return
//        }
//
//        var contentInsets = UIEdgeInsets.zero
//        contentInsets.bottom = keyboardFrame.size.height
//
//        superview?.layoutIfNeeded()
//        UIView.animate(withDuration: 0.3) {
//            self.superview?.layoutIfNeeded()
//            self.window?.windowScene?.keyWindow?.rootViewController?.view.layoutIfNeeded()
//        }
//    }
//
//    @objc private func keyboardWillHide(_ notification: Notification) {
////        var contentInsets = UIEdgeInsets.zero
//
//        superview?.layoutIfNeeded()
//        UIView.animate(withDuration: 0.3) {
//            self.superview?.layoutIfNeeded()
//            self.window?.windowScene?.keyWindow?.rootViewController?.view.layoutIfNeeded()
//        }
//    }
}
