//
//  Category.swift
//  CoreDataAPP
//
//  Created by NAZISH ZOHAIB on 04/03/2020.
//  Copyright © 2020 NAZISH ZOHAIB. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
}
