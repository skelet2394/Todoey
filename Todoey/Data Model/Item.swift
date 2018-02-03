//
//  Item.swift
//  Todoey
//
//  Created by Valery Silin on 03/02/2018.
//  Copyright © 2018 Valery Silin. All rights reserved.
//

import Foundation
import RealmSwift
class Item: Object {
    @objc dynamic var title = ""
    @objc dynamic var done = false
    var parentDirectory = LinkingObjects(fromType: Category.self, property: "items")

}
