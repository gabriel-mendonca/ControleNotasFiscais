//
//  NSNavigationViewController.swift
//  ControleNotasFiscais
//
//  Created by Gabriel Estudos on 07/05/23.
//

import UIKit

class NSNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().isTranslucent = false
        navigationBar.standardAppearance.backgroundColor = .white
        UINavigationBar.appearance().standardAppearance.backgroundColor = .white
        UINavigationBar.appearance().barTintColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1.0)
        
//        delegate = self
        
//        let backButton = UIBarButtonItem()
//        backButton.title = ""
//        navigationBar.topItem?.backBarButtonItem = backButton
    }
    
}

extension NSNavigationViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.navigationBar.isTranslucent = false
        
//        navigationController.navigationBar.standardAppearance.backgroundColor =
//        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
}
