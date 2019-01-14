//
//  Item.swift
//  Todo List
//
//  Created by Rizwan on 1/13/19.
//  Copyright © 2019 Course. All rights reserved.
//

import Foundation
import RealmSwift

class RealmItem: Object{
    @objc dynamic var itemName = ""
    @objc dynamic var dateCreated = Date()
    @objc dynamic var itemSelected = false
    
    var parentCategory = LinkingObjects(fromType: CategoryData.self, property: "catItems")
    
}
