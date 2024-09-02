//
//  TextFieldExtension.swift
//  RxSwiftDemo
//
//  Created by Sachin Sardana on 30/08/24.
//

import UIKit
extension UITextField {
    func addLeftPadding(padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
