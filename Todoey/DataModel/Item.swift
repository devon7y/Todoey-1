//
//  Item.swift
//  Todoey
//
//  Created by Udit Kapahi on 20/03/18.
//  Copyright © 2018 Udit Kapahi. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title:String = ""
    @objc dynamic var done:Bool = false
    @objc dynamic var date:Date = Date()
//    LinkingObjects is an auto-updating container type. It represents zero or more objects that are linked to its owning model object through a property relationship.
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
