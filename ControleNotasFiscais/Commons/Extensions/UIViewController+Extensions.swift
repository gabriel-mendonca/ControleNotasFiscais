//
//  UIViewController+Extensions.swift
//  ControleNotasFiscais
//
//  Created by Gabriel Estudos on 06/05/23.
//

import UIKit

extension UIViewController {
    func showMessage(_ title:String,_ message :String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showMessageOnTimer(_ title:String,_ message :String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func hideKeyBoardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func hideNavigationBar(_ animated: Bool) {
       self.navigationController?.setNavigationBarHidden(true, animated: animated)
       
   }
   
   func showNavigationBar(_ animated: Bool) {
       self.navigationController?.setNavigationBarHidden(false, animated: animated)
   }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
