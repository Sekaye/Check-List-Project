//
//  CategoryViewControllTableViewController.swift
//  ToDoeyProject
//
//  Created by Sekaye Knutson on 6/30/22.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray: [ItemCategory] = []
    
    let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backgroundColor = UIColor.systemCyan
        configure()
        loadCategories()
        
    }
    
    // MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Lane Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { action
            in
            
            //what happens once the add button is clicked
            
            if let text = textField.text {
                let newCategory = ItemCategory(context: self.context)
                newCategory.name = text
                self.categoryArray.append(newCategory)
                self.saveCategories()
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


// MARK: - Table view data source control

extension CategoryViewController {
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellID, for: indexPath)
        as! ToDoTableViewCell
        let category = categoryArray[indexPath.row]
        cell.itemLabel.text = ""
        cell.itemLabel.text = category.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: K.categoryExitSegue, sender: self)
        saveCategories()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
}


// MARK: - Data manipulation methods
extension CategoryViewController {
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("error saving context \(error)")
        }
    }

    func loadCategories(with request: NSFetchRequest<ItemCategory> = ItemCategory.fetchRequest()){
        do{
            categoryArray = try context.fetch(request)
        }
        catch {
            print("error fetching data from context \(error)")
        }
    }
}

// MARK: - Utility methods

extension CategoryViewController {
    func configure() {
        tableView.register(UINib(nibName: K.listNibName, bundle: nil), forCellReuseIdentifier: K.cellID)
    }
}



