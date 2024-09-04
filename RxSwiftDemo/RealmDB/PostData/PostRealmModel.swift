//
//  PostRealmModel.swift
//  RxSwiftDemo
//
//  Created by Sachin Sardana on 04/09/24.
//

import Foundation
import RealmSwift

class PostRealmModel: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var body: String = ""
    @objc dynamic var isFavorite: Bool = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
