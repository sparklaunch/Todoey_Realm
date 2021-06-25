//
//  ItemViewController.swift
//  Todoey_Realm
//
//  Created by Jinwook Kim on 2021/06/25.
//

import UIKit

class ItemViewController: UITableViewController {
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
