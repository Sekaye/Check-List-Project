//
//  SwipeTableViewController.swift
//  ToDoeyProject
//
//  Created by Sekaye Knutson on 7/21/22.
//

import UIKit
import SwipeCellKit
import DynamicColor

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
        tableView.rowHeight = 60.0
    }
    
    func colorCell(previousColor: UIColor, cellCount: Int) -> UIColor {
        var changeAmount = 0.0
        var currentColor = previousColor.darkened(amount: 0.1) //.6 is max for visibility
        currentColor = currentColor.saturated(amount: 0.1)
        return currentColor
    }
    
    func colorCellString() -> String {
        var baseColors: [String] = []
        
        let color1 = UIColor(hexString: "#6110ef").lighter(amount: 0.4).desaturated(amount: 0.1).toHexString()
        let color2 = UIColor(hexString: "#c610ef").lighter(amount: 0.4).desaturated(amount: 0.1).toHexString()
        let color3 = UIColor(hexString: "#ef1073").lighter(amount: 0.4).desaturated(amount: 0.1).toHexString()
        let color4 = UIColor(hexString: "#fa8705").lighter(amount: 0.4).desaturated(amount: 0.1).toHexString()
        let color5 = UIColor(hexString: "#2096df").lighter(amount: 0.4).desaturated(amount: 0.1).toHexString()
        let color6 = UIColor(hexString: "#1c1ae5").lighter(amount: 0.4).desaturated(amount: 0.1).toHexString()
        
        baseColors.append(color1)
        baseColors.append(color2)
        baseColors.append(color3)
        baseColors.append(color4)
        baseColors.append(color5)
        baseColors.append(color6)
        
        return baseColors.randomElement()!
    }
}
