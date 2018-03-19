//
//  Item.swift
//  Todoey
//
//  Created by Udit Kapahi on 16/03/18.
//  Copyright © 2018 Udit Kapahi. All rights reserved.
//

import Foundation

class Item:Codable{
    var title:String = ""
    var done:Bool = false
}

// extending encodable makes your model to be saved in a json or a plist file
// also the properties must be standard datatypes
// It should also use decodable for swift to make it decodable.
// so instead of extending both encodable and decodable , we can only extends Codabale

