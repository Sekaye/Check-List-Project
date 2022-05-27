//
//  ViewController.swift
//  ToDoeyProject
//
//  Created by Sekaye Knutson on 5/19/22.
//

import UIKit

class ListViewController: UITableViewController {
    
    var itemArray = ["Toothbrush",
                     "Watch",
                     "Sleeping Bag",
                     "Passport and Customs Docs"]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor = UIColor.systemCyan
        tableView.register(UINib(nibName: K.nibName, bundle: nil), forCellReuseIdentifier: K.cellID)
        if let items = defaults.array(forKey: K.defaultKey) as? [String] {
            itemArray = items
        }
    }
    // MARK: - Add items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add an Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "New Item", style: .default) { action in
            //what happens once the add button is clicked
            if let text = textField.text {
                self.itemArray.append(text)
                ListManager.emptyCells()
                self.defaults.set(self.itemArray, forKey: K.defaultKey)
                self.tableView.reloadData()
            }
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
}

// MARK: - List Data Source Methods
extension ListViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellID, for: indexPath)
        as! ToDoTableViewCell
        cell.itemLabel.text = ""
        cell.itemLabel.text = itemArray[indexPath.row]
        ListManager.saveCell(cell: cell)
        return cell
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
}

// MARK: - Changes When Items Are Selected
extension ListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = MainList.cellList[indexPath.item]
        
        // checks and unchecks list items
        if cell.checkImage.isHidden {
            cell.checkImage.isHidden = false
        } else {
            cell.checkImage.isHidden = true
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


