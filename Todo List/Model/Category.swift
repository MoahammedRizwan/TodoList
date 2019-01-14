//
//  Category.swift
//  Todo List
//
//  Created by Rizwan on 1/13/19.
//  Copyright © 2019 Course. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryData: Object {
    @objc dynamic var categoryName : String = ""
    let catItems = List<RealmItem>()
}
