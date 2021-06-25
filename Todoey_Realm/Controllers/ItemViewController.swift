//
//  ItemViewController.swift
//  Todoey_Realm
//
//  Created by Jinwook Kim on 2021/06/25.
//

import UIKit
import RealmSwift

class ItemViewController: SwipeViewController {
    @IBOutlet var searchBar: UISearchBar!
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
    override func remove(at index: Int) {
        if let targetItem: Item = self.items?[index] {
            do {
                try self.realm.write {
                    self.realm.delete(targetItem)
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
        let cell: UITableViewCell = super.tableView(self.tableView, cellForRowAt: indexPath)
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

// MARK: - UITableViewDelegate

extension ItemViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedItem: Item = self.items?[indexPath.row] {
            do {
                try self.realm.write {
                    selectedItem.isChecked.toggle()
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

// MARK: - UISearchBarDelegate

extension ItemViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text: String = self.searchBar.text!
        let predicate: NSPredicate = NSPredicate(format: "name CONTAINS[cd] %@", text)
        self.loadItems(with: predicate)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if self.searchBar.text!.count == 0 {
            self.searchBar.resignFirstResponder()
            self.loadItems()
        }
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
    func loadItems(with predicate: NSPredicate) {
        self.items = self.parentCategory!.items.filter(predicate).sorted(byKeyPath: "created", ascending: true)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
