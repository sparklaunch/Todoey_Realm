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
        self.loadItems()
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField = UITextField()
        let alert: UIAlertController = UIAlertController(title: "Add a new item", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField: UITextField) in
            alertTextField.placeholder = "Enter a new item name"
            textField = alertTextField
        }
        let action: UIAlertAction = UIAlertAction(title: "Add", style: .default) { (action: UIAlertAction) in
            let text: String = textField.text!
            self.addItem(with: text)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
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
            cell.accessoryType = item.isChecked ? .checkmark : .none
        }
        else {
            cell.textLabel?.text = "No items added yet."
        }
        return cell
    }
}

// MARK: - Create

extension ItemViewController {
    func addItem(with name: String) {
        let newItem: Item = Item()
        newItem.name = name
        newItem.created = Date().timeIntervalSince1970
        if let currentCategory: Category = self.parentCategory {
            do {
                try self.realm.write {
                    currentCategory.items.append(newItem)
                    self.realm.add(newItem)
                }
            }
            catch let error {
                let localizedError: String = error.localizedDescription
                print(localizedError)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - Read

extension ItemViewController {
    func loadItems() {
        self.items = self.parentCategory!.items.sorted(byKeyPath: "created", ascending: true)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
