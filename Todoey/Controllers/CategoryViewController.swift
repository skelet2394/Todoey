//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Valery Silin on 02/02/2018.
//  Copyright © 2018 Valery Silin. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
        
    }
    
    // MARK: - TableView Datasource and Delegate Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added here yet"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Unable to save context \(error)")
        }
        tableView.reloadData()
    }
    func loadCategory () {
        categories = realm.objects(Category.self).sorted(byKeyPath: "created", ascending: false)
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if let category = categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(category, cascading: true)
                }
            } catch {
                print("Error  deleting category \(error)")
            }
            tableView.reloadData()
        }
    }
    
    // MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField = UITextField()
        let alert = TextEnabledAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancelAction) in
        }
        let addCategory = UIAlertAction(title: "Add", style: .default) { (addAction) in
            let newCategory = Category()
            newCategory.name = alertTextField.text!
            self.save(category: newCategory)
        }
        addCategory.isEnabled = false
        alert.addAction(addCategory)
        alert.addAction(cancelAction)
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Create a new category"
        }) { (textField) in
            addCategory.isEnabled = textField.text?.count != 0
            alertTextField = textField
        }
        present(alert, animated: true, completion: nil)
    }
}


//MARK: - Search


extension CategoryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadCategory()
        } else {
            categories = categories?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
            tableView.reloadData()
        }
    }
}

