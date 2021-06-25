//
//  SwipeViewController.swift
//  Todoey_Realm
//
//  Created by Jinwook Kim on 2021/06/25.
//

import UIKit
import SwipeCellKit

class SwipeViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - UITableViewDataSource

extension SwipeViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SwipeTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
}

// MARK: - SwipeTableViewCellDelegate

extension SwipeViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right
        else {
            return nil
        }
        let deleteAction: SwipeAction = SwipeAction(style: .destructive, title: "Delete") { (swipeAction: SwipeAction, indexPath: IndexPath) in
            self.remove(at: indexPath.row)
        }
        deleteAction.image = UIImage(systemName: "trash")
        return [deleteAction]
    }
}

// MARK: - Delete

extension SwipeViewController {
    func remove(at index: Int) {
        // The subclasses will do the task.
    }
}
