//
//  Item.swift
//  Todoey_Realm
//
//  Created by Jinwook Kim on 2021/06/25.
//

import RealmSwift

class Item: Object {
    @objc dynamic var name: String = ""
    var parentCategory: LinkingObjects<Category> = LinkingObjects<Category>(fromType: Category.self, property: "items")
}
