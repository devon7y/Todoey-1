//
//  Data.swift
//  Todoey
//
//  Created by Udit Kapahi on 20/03/18.
//  Copyright © 2018 Udit Kapahi. All rights reserved.
//

import Foundation
import RealmSwift

//AN object is a class used to define a realm model obbject, this is the super class that we are using to enable a s to save and persist data class
class Data:Object{
    //dynamic is called as a declaration modifier, it basically tells the runtime to use the dynamic dispatch over the standard staatic dispatch
    // dynamic allows this property name to be monitored for change at runtime while the app is running
    // these @objc dynamic keywords allows realm to montior the changes in these two proprtirs
    @objc dynamic var name:String = ""
    @objc dynamic var age:Int = 0
}
