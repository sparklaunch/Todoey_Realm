//
//  CategoryViewController.swift
//  Todoey_Realm
//
//  Created by Jinwook Kim on 2021/06/25.
//

import UIKit

class CategoryViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
}

// MARK: - Initialization

extension CategoryViewController {
    func initialize() {
        self.title = "Categories"
    }
}
