//
//  ViewController.swift
//  ToDoeyProject
//
//  Created by Sekaye Knutson on 5/19/22.
//

import UIKit
import RealmSwift

class ListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var toDoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory: Category? {
        didSet { //called as soon as selectedCategory is given a value
            loadItems() //ensures items are loaded only once selectedCategory has a value
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        loadItems()
    }
    
    // MARK: - Delete Items
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(itemForDeletion)
                }
            } catch {
                print("error deleting data \(error)")
            }
        }
    }
}

// MARK: - Search Bar Control
extension ListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        switch searchBar.text?.count {
        case 0:
            loadItems()
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        default:
            let results = toDoItems?.where({ item in
                item.title.contains(searchBar.text!, options: .caseInsensitive)
            })
            toDoItems = results?.sorted(byKeyPath: "dateCreated", ascending: true)
            tableView.reloadData()
        }
    }
}

// MARK: - Table view list control
extension ListViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        as! ToDoTableViewCell
        if let item = toDoItems?[indexPath.row] {
            cell.itemLabel.text = ""
            cell.itemLabel.text = item.title
            cell.checkImage.isHidden = item.done ? false : true //does the same thing as below
            ListManager.saveCell(cell: cell)
            return cell
        } else {
            cell.itemLabel.text = "No items added"
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
}

// MARK: - Item selected
extension ListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write({
                    item.done = !item.done
                })
            } catch {
                print("error saving new data \(error)")
            }
            let cell = MainList.cellList[indexPath.row]
            cell.checkImage.isHidden = item.done ? false : true
        }
//        let cell = MainList.cellList[indexPath.item]
//        // checks and unchecks list items
//        if cell.checkImage.isHidden {
//            cell.checkImage.isHidden = false
//        } else {
//            cell.checkImage.isHidden = true
//        }
        //        toDoItems[indexPath.row].done = !toDoItems[indexPath.row].done
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Add Item Control
extension ListViewController {
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Lane Item", message: "", preferredStyle: .alert)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        present(alert, animated: true)
        
        let action = UIAlertAction(title: "Add", style: .default) { action
            in
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write({
                        print("attempting to save")
                        let newItem = Item()
                        self.realm.add(newItem)
                        newItem.title = textField.text ?? ""
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    })
                } catch {
                    print("error saving items \(error)")
                }
            }
            self.loadItems()
            self.tableView.reloadData()
        }
        alert.addAction(action)
    }
}

// MARK: - Utility Methods
extension ListViewController {
    
    func loadItems(){
        toDoItems = selectedCategory!.items.sorted(byKeyPath: "title", ascending: true)

    }
    
    func configuration(){
        
        //register searchbar delegate
                searchBar.delegate = self
        
        //register custom table cells
        tableView.register(UINib(nibName: K.listNibName, bundle: nil), forCellReuseIdentifier: K.cellID)
        
        //sets nav bar color to cyan
        navigationController?.navigationBar.backgroundColor = UIColor.systemCyan
        
        
    }
}
