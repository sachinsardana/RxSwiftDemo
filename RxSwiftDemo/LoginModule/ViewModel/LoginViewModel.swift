//
//  LoginViewModel.swift
//  RxSwiftDemo
//
//  Created by Sachin Sardana on 27/08/24.
//
import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    
    let emailText = PublishSubject<String>()
    let passwordText = PublishSubject<String>()
    var isEmailValid: Observable<Bool>!
    var isPasswordValid: Observable<Bool>!
    var isFormValid: Observable<Bool>!
    
    init() {
        isEmailValid = emailText
            .map { email in
                return self.isValidEmail(email)
            }
        
        isPasswordValid = passwordText
            .map { password in
                return password.count >= 8 && password.count <= 15
            }
        
        isFormValid = Observable.combineLatest(isEmailValid, isPasswordValid) { isEmailValid, isPasswordValid in
            return isEmailValid && isPasswordValid
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: email)
    }
}

