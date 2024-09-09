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
    
    private let validations: LoginValidationsProtocol
    
    init(validations: LoginValidationsProtocol) {
        self.validations = validations
        //Email Validating
        isEmailValid = emailText
            .map { email in
                return validations.isValidEmail(email)
            }
        
        //Password Validating
        isPasswordValid = passwordText
            .map { password in
                return validations.isValidPassword(password)
            }
        
        //Email & Password Validating
        isFormValid = Observable.combineLatest(isEmailValid, isPasswordValid) { isEmailValid, isPasswordValid in
            return isEmailValid && isPasswordValid
        }
    }
}

