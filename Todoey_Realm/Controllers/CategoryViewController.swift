//
//  CategoryViewController.swift
//  Todoey_Realm
//
//  Created by Jinwook Kim on 2021/06/25.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    let realm: Realm = try! Realm()
    var categories: Results<Category>?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
        self.loadCategories()
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField = UITextField()
        let alert: UIAlertController = UIAlertController(title: "Add a new category", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField: UITextField) in
            alertTextField.placeholder = "Enter a new category name"
            textField = alertTextField
        }
        let action: UIAlertAction = UIAlertAction(title: "Add", style: .default) { (action: UIAlertAction) in
            let text: String = textField.text!
            self.addCategory(with: text)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Initialization

extension CategoryViewController {
    func initialize() {
        self.title = "Categories"
    }
}

// MARK: - UITableViewDataSource

extension CategoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "Cell")!
        if let category: Category = self.categories?[indexPath.row] {
            cell.textLabel?.text = category.name
        }
        else {
            cell.textLabel?.text = "No categories added yet."
        }
        return cell
    }
}

// MARK: - Create

extension CategoryViewController {
    func addCategory(with name: String) {
        let newCategory: Category = Category()
        newCategory.name = name
        do {
            try self.realm.write {
                self.realm.add(newCategory)
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

// MARK: - Read

extension CategoryViewController {
    func loadCategories() {
        self.categories = self.realm.objects(Category.self)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
