//
//  ItemViewController.swift
//  Todoey_Realm
//
//  Created by Jinwook Kim on 2021/06/25.
//

import UIKit
import RealmSwift

class ItemViewController: UITableViewController {
    var items: Results<Item>?
    let realm: Realm = try! Realm()
    var parentCategory: Category? {
        didSet {
            self.initialize(with: self.parentCategory!.name)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Initialization

extension ItemViewController {
    func initialize(with title: String) {
        self.title = title
    }
}

// MARK: - UITableViewDataSource

extension ItemViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "Cell")!
        if let item: Item = self.items?[indexPath.row] {
            cell.textLabel?.text = item.name
        }
        else {
            cell.textLabel?.text = "No items added yet."
        }
        return cell
    }
}

// MARK: - Create

extension ItemViewController {
    
}

// MARK: - Read

extension ItemViewController {
    func loadItems() {
        let predicate: NSPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", self.parentCategory!.name)
        self.items = self.realm.objects(Item.self).filter(predicate)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
