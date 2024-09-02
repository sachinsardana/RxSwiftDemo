//
//  StringExtension.swift
//  RxSwiftDemo
//
//  Created by Sachin Sardana on 31/08/24.
//

import Foundation
extension String {
    var capitalizingFirstLetter: String {
        return prefix(1).capitalized + dropFirst()
    }
}
