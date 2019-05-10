//
//  Category.swift
//  Todoey
//
//  Created by Emre on 10/05/2019.
//  Copyright © 2019 Emre Baris Yavuz. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    
    let items = List<Item>()
    
}
