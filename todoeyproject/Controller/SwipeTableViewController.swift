//
//  SwipeTableViewController.swift
//  ToDoeyProject
//
//  Created by Sekaye Knutson on 7/21/22.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSwipeView()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            self.updateModel(at: indexPath)
            
            print("delete cell")
        }
        deleteAction.image = UIImage(systemName: "trash.circle")
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
    
    func updateModel(at indexPath: IndexPath) {
        //Override in child class to update model data upon deletion
    }
    
    
}

// MARK: - Table view data source methods
extension SwipeTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        as! ToDoTableViewCell
        
        cell.delegate = self
        
        return cell
    }
}


// MARK: - Utility methods
extension SwipeTableViewController {
    
    func configureSwipeView() {
        tableView.register(UINib(nibName: K.listNibName, bundle: nil), forCellReuseIdentifier: "Cell")
    }
}
