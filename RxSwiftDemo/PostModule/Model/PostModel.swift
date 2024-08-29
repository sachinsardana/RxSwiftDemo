//
//  PostModel.swift
//  RxSwiftDemo
//
//  Created by Sachin Sardana on 28/08/24.
//

import Foundation
struct PostModel : Codable {
    let id : Int
    let body : String
    let title : String
    let isfavorite : Bool?
}
