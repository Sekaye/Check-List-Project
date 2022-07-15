//
//  ViewController.swift
//  ToDoeyProject
//
//  Created by Sekaye Knutson on 5/19/22.
//

import UIKit
import CoreData

class ListViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var itemArray: [Item] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCategory: ItemCategory? {
        didSet { //called as soon as selectedCategory is given a value
            print("ERROR FLAG 1")
            print(selectedCategory?.name)
            loadItems() //ensures items are loaded only once selectedCategory has a value
        }
    }
    
    
    let dataFilePath = FileManager
        .default
        .urls(for: .documentDirectory, in: .userDomainMask)
        .first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        print(dataFilePath)
        loadItems()
        
        
    }
}

// MARK: - Search Bar Control
extension ListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, with: predicate)
        
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

// MARK: - Table view list control
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

// MARK: - Item Selection and Related Methods
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

// MARK: - Add Item Control
extension ListViewController {
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Lane Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { action
            in
            
            //what happens once the add button is clicked
            
            if let text = textField.text {
                let newItem = Item(context: self.context)
                newItem.title = text
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
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

// MARK: - Utility Methods
extension ListViewController {
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("error saving context \(error)")
        }
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), with predicate: NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do{
            print("THIS IS ITEMARRAY \(itemArray)")
            print("THIS IS THE REQUEST\(request)")
            itemArray = try context.fetch(request)
            print("THIS IS ITEMARRAY2 \(itemArray)")
        }
        catch {
            print("error fetching data from context \(error)")
        }
    }
    
    //configuration on loading
    func configuration(){
        
        //register searchbar delegate
        searchBar.delegate = self
        
        //register custom table cells
        tableView.register(UINib(nibName: K.listNibName, bundle: nil), forCellReuseIdentifier: K.cellID)
        
        //sets nav bar color to cyan
        navigationController?.navigationBar.backgroundColor = UIColor.systemCyan
        
        
    }
}
