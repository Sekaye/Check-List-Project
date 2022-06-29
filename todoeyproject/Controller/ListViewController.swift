//
//  ViewController.swift
//  ToDoeyProject
//
//  Created by Sekaye Knutson on 5/19/22.
//

import UIKit
import CoreData

class ListViewController: UITableViewController {
    
    var itemArray: [Items] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let dataFilePath = FileManager
        .default
        .urls(for: .documentDirectory, in: .userDomainMask)
        .first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath)
                
        navigationController?.navigationBar.backgroundColor = UIColor.systemCyan
        tableView.register(UINib(nibName: K.nibName, bundle: nil), forCellReuseIdentifier: K.cellID)
//        if let items = defaults.array(forKey: K.defaultKey) as? [Item] {
//            itemArray = items
//        }
        
//        loadItems()
        
    }

}

// MARK: - List Data Source Methods
extension ListViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellID, for: indexPath)
        as! ToDoTableViewCell
        let item = itemArray[indexPath.row]
        cell.itemLabel.text = ""
        cell.itemLabel.text = item.title
        cell.checkImage.isHidden = item.done ? false : true //does the same thing as below
//
//        if item.done {
//            cell.checkImage.isHidden = false
//        } else {
//            cell.checkImage.isHidden = true
//        }
        
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
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.deselectRow(at: indexPath, animated: true)
        saveItems()
    }
    
}

// MARK: - Add items
extension ListViewController {
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Lane Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { action
            in
            //what happens once the add button is clicked
            
            if let text = textField.text {
                let newItem = Items(context: self.context)
                newItem.title = text
                newItem.done = false
                self.itemArray.append(newItem)
                ListManager.emptyCells()
                self.saveItems()
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

// MARK: - Utility functions
extension ListViewController {
    
    //encoder
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("error saving context \(error)")
        }
    }
    
    //decoder
//    func loadItems(){
//        if let data = try? Data(contentsOf: dataFilePath!){ //there may not always be data to decode
//            let decoder = PropertyListDecoder()
//            do {
//                itemArray = try decoder.decode([Item].self, from: data)
//            } catch {
//                print("error decoding array\(error)")
//            }
//        }
//    }
}
