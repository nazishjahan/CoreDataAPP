//
//  Item.swift
//  CoreDataAPP
//
//  Created by NAZISH ZOHAIB on 04/03/2020.
//  Copyright © 2020 NAZISH ZOHAIB. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    let parentCategory = LinkingObjects(fromType: Category.self , property: "items")
}
