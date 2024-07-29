//
//  UITextField+Extension.swift
//  Hospital Inspection
//
//  Created by Kamlesh Nimradkar on 26/07/24.
//

import Foundation
import UIKit

extension UITextField {
    func setTxtFieldPlaceholder(text: String, color: UIColor = UIColor(white: 0.45, alpha: 0.60)) {
        self.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: color])
    }
    
    func addPadding(){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func addBottomBorderWithColor(color: UIColor) {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0.0, y: self.frame.size.height - 1, width: self.frame.width, height: 1.0)
        bottomBorder.backgroundColor = color.cgColor
        self.layer.addSublayer(bottomBorder)
    }
}


extension UIViewController {
    func showAlertMessage(_ message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(ok)
        present(alertController, animated: true)
    }
}
