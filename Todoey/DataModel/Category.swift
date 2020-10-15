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
    let items = List<Item>()
}
