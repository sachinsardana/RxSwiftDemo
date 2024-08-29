//
//  PostEntity+CoreDataProperties.swift
//  
//
//  Created by Sachin Sardana on 28/08/24.
//
//

import Foundation
import CoreData


extension PostEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostEntity> {
        return NSFetchRequest<PostEntity>(entityName: "PostEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var body: String?
    @NSManaged public var title: String?
    @NSManaged public var isfavorite: Bool

}
