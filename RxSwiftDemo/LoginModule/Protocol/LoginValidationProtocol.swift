//
//  LoginValidationProtocol.swift
//  RxSwiftDemo
//
//  Created by Sachin Sardana on 27/08/24.
//

import Foundation
protocol LoginValidationsProtocol {
    func isValidEmail(_ email: String) -> Bool
    func isValidPassword(_ password: String) -> Bool
}
