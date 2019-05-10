//
//  Item.swift
//  Todoey
//
//  Created by Emre on 10/05/2019.
//  Copyright © 2019 Emre Baris Yavuz. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
