//
//  LoginValidations.swift
//  RxSwiftDemo
//
//  Created by Sachin Sardana on 27/08/24.
//

import Foundation
class LoginValidations: LoginValidationsProtocol {
    //Email Validate Method
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: email)
    }
    //Password Validate Method
    func isValidPassword(_ password: String) -> Bool {
        return password.count >= 8 && password.count <= 15
    }
}
