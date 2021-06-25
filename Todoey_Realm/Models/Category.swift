//
//  Category.swift
//  Todoey_Realm
//
//  Created by Jinwook Kim on 2021/06/25.
//

import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var created: TimeInterval = 0.0
    let items: List<Item> = List<Item>()
}
