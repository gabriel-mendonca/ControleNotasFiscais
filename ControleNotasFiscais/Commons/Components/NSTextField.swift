//
//  TextField+Extension.swift
//  ControleNotasFiscais
//
//  Created by Gabriel Mendonça on 05/05/23.
//

import UIKit

class NSTextField: UITextField {
    
    var edge: UIEdgeInsets!
    
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
    
    func setLeftEdgeInsetsPadding(left: CGFloat) {
        self.edge = UIEdgeInsets(top: 0, left: left, bottom: 0, right: 0)
    }
}
