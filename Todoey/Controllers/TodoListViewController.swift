//
//  ViewController.swift
//  Todoey
//
//  Created by Emre on 06/05/2019.
//  Copyright © 2019 Emre Baris Yavuz. All rights reserved.
//

import UIKit
import RealmSwift
// import SwipeCellKit

class TodoListViewController: UITableViewController {
    
    // @IBOutlet weak var searchBar: UISearchBar!
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        
        didSet {
            
            loadItems()
            
        }
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Delegate of search bar is set on Main Storyboard. So commented out.
        // searchBar?.delegate = self
        
        // Items are loaded based on the category selected in Category View. So commented out.
        //loadItems()
        
    }

    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
//        let item = todoItems[indexPath.row]
//
//        cell.textLabel?.text = item.title
//
//        // Value = condition ? valueIfTrue : valueIfFalse
//        cell.accessoryType = item.done ? .checkmark : .none

        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            // Value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
            
        }
        else {
            
            cell.textLabel?.text = "No items added"
            
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
        
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Deleting the selected row.
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        // Checks/unchecks selected row.
        // todoItems[indexPath.row].done = !todoItems[indexPath.row].done
        
        // saveItems()
        
        if let item = todoItems?[indexPath.row] {
            
            do {
                
                try realm.write {
                    
                    item.done = !item.done
                    
                    // To delete.
                    // realm.delete(item)
                    
                }
                
            }
            catch {
                
                print("Error changing item's done property: \(error)")
                
            }
            
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField: UITextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            print("Success for Add New Item action.")
            
            if let currentCategory = self.selectedCategory {
                
                do {
                    
                    try self.realm.write {
                        
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                        
                    }
                    
                }
                    
                catch {
                    
                    print("Error saving new item: \(error)")
                    
                }
                
            }
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Add a new item"
            
            print("addTextField is created.")
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Data Manipulation Methods
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)

        tableView.reloadData()

    }
    
}

// MARK: - SearchBar Methods
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {

            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }

    }

}

// MARK: - PickerView Methods
//extension TodoListViewController: UIPickerViewDelegate {
//
//    <#code#>
//
//}

// MARK: - ImagePickerController Methods
//extension TodoListViewController: UIImagePickerControllerDelegate {
//
//    <#code#>
//
//}
