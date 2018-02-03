//
//  Category.swift
//  Todoey
//
//  Created by Valery Silin on 03/02/2018.
//  Copyright © 2018 Valery Silin. All rights reserved.
//

import Foundation
import RealmSwift
class Category: Object {
    @objc dynamic var name = ""
    let items = List<Item>()
}
