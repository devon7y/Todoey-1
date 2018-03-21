//
//  Category.swift
//  Todoey
//
//  Created by Udit Kapahi on 20/03/18.
//  Copyright © 2018 Udit Kapahi. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var attribute:String = ""
    @objc dynamic var color:String = ""
//    List comes from Realm and is a container type for one to many relationships
    let items = List<Item>()
}
