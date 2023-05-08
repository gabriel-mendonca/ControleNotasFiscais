//
//  TextField+Extension.swift
//  ControleNotasFiscais
//
//  Created by Gabriel Mendonça on 05/05/23.
//

import UIKit

class NSTextField: UITextField {
    
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
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: edge)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: edge)
    }
    
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
}
