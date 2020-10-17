//
//  Category.swift
//  Todoey
//
//  Created by Valeria Heikkila on 2020/10/15.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var cellColor : String = ""
    let items = List<Item>()
}
