//
//  UIViewController+Extensions.swift
//  GithubSearchTask
//
//  Created by Hasan Gyulyustan on 19.12.21.
//

import UIKit

extension UIViewController {
    
    func showAlertViewControllerWithTitle(_ title:String, message:String = "", actions:[UIAlertAction]? = [UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let actions = actions {
            for action in actions {
                if action.style == .default {
                    action.setValue(UIColor.blue, forKey: "titleTextColor")
                }
                else if action.style == .cancel {
                    action.setValue(UIColor.darkGray, forKey: "titleTextColor")
                }
                else if action.style == .destructive {
                    action.setValue(UIColor.red, forKey: "titleTextColor")
                }
                
                alert.addAction(action)
            }
        }
        
        // Background
        let backView = alert.view.subviews.first?.subviews.first?.subviews.first
        backView?.layer.cornerRadius = 10.0
        backView?.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:0.82)
        
        alert.removeFromParent()
        self.present(alert, animated: true, completion: nil)
    }
}
