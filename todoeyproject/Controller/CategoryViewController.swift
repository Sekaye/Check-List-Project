//
//  CategoryViewControllTableViewController.swift
//  ToDoeyProject
//
//  Created by Sekaye Knutson on 6/30/22.
//

import UIKit
import CoreData
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
    var categories: Results<Category>?
    
    let realm = try! Realm()
    
    var cellColor: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backgroundColor = UIColor.systemCyan
        configure()
        configureUI()
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
                if self.categories != nil {
                    if self.categories!.count > 0 {
                        let prevColor = self.categories![self.categories!.count - 1].color
                        let newColor = self.colorCell(previousColor: UIColor(hexString: prevColor), cellCount: self.categories!.count)
                        newCategory.color = newColor.toHexString()
                        print("first")
                                                      
                    } else {
                        newCategory.color = self.colorCellString()
                        print("second")
                    }
                }
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
    
    // MARK: - Delete Items
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(categoryForDeletion)
                }
            } catch {
                print("error deleting data \(error)")
            }
        }
    }
}


// MARK: - Cell control and configuration
extension CategoryViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        as! ToDoTableViewCell
        
        cell.itemLabel.text = categories?[indexPath.row].name ?? "No Categories Added"
        print(categories![indexPath.row].color)
        cell.backgroundColor = UIColor(hexString: categories![indexPath.row].color)
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories!.count
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
    
    // MARK: - Delete Data From Swipe

    
}

// MARK: - Utility methods

extension CategoryViewController {
    func configure() {
        tableView.register(UINib(nibName: K.listNibName, bundle: nil), forCellReuseIdentifier: K.cellID)
        tableView.separatorStyle = .none
    }
    
    func configureUI() {
    }
}



