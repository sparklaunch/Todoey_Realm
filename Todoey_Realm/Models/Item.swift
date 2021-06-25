//
//  Item.swift
//  Todoey_Realm
//
//  Created by Jinwook Kim on 2021/06/25.
//

import RealmSwift

class Item: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var created: TimeInterval = 0.0
    @objc dynamic var isChecked: Bool = false
    var parentCategory: LinkingObjects<Category> = LinkingObjects<Category>(fromType: Category.self, property: "items")
}
