//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Emre on 09/05/2019.
//  Copyright © 2019 Emre Baris Yavuz. All rights reserved.
//

import UIKit
import RealmSwift
// import SwipeCellKit

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80

        loadCategories()
    }
    
    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let category = categories?[indexPath.row]
        
        cell.textLabel?.text = category?.name ?? "No categories added yet"
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
        
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationViewController = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {

            destinationViewController.selectedCategory = categories?[indexPath.row]

        }
        
    }
    
    // MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField: UITextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            print("Success for Add New Category action.")

            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.saveCategory(category: newCategory)
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Add a new category"
            
            print("addTextField is created.")
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Data Manipulation Methods
    
    func saveCategory(category: Category) {

        do {
            
            try realm.write {
                
                realm.add(category)
                
            }
            
        }
        
        catch {
            
            print("Error saving category: \(error)")
            
        }
        
        self.tableView.reloadData()

    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    
    // MARK: - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        
        // No need to call the superclass. There is nothing there.
        // super.updateModel(at: indexPath)
        
        // Update data model.
        if let category = categories?[indexPath.row] {
            
            do {
                
                try self.realm.write {
                    
                    self.realm.delete(category)
                    
                }
                
            }
            catch {
                
                print("Error while deleting a category: \(error)")
                
            }
            
        }
    }
}
