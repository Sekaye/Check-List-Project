//
//  CategoryViewControllTableViewController.swift
//  ToDoeyProject
//
//  Created by Sekaye Knutson on 6/30/22.
//

import UIKit
import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {
    
    var categories: Results<Category>?
    
    let realm = try! Realm()
    
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
                let newCategory = Category()
                newCategory.name = text
                self.save(category: newCategory)
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
        let category = categories?[indexPath.row]
        cell.itemLabel.text = ""
        cell.itemLabel.text = category?.name ?? "No lists added yet"
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    
    // MARK: - Category selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        loadCategories()
        performSegue(withIdentifier: K.categoryExitSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            let currentCategory = categories?[indexPath.row]
            try! realm.write({
                realm.add(currentCategory!, update: .all)
                realm.add(currentCategory!.items, update: .all)
            })
            destinationVC.selectedCategory = currentCategory
        }
    }
}


// MARK: - Data manipulation methods
extension CategoryViewController {
    
    func save(category: Category) {
        do {
//            try context.save() *for CoreData*
            try realm.write{   // for Realm
                realm.add(category)
            }
        } catch {
            print("error saving context \(error)")
        }
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
    }
}

// MARK: - Utility methods

extension CategoryViewController {
    func configure() {
        tableView.register(UINib(nibName: K.listNibName, bundle: nil), forCellReuseIdentifier: K.cellID)
    }
}



