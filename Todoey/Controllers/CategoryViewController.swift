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
        categories = realm.objects(Category.self)
    }
//    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
//
//        do {
//          category = try context.fetch(Category.fetchRequest())
//        } catch  {
//            print("Error fetching request \(error)")
//        }
//        tableView.reloadData()
//  }
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
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancelAction) in
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { (addAction) in
            let newCategory = Category()
            if textField.text == "" {
               textField.text = "Unnamed category"
            }
                newCategory.name = textField.text!
                self.save(category: newCategory)
        }
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        alert.addTextField { (field) in
            field.placeholder = "Create a new category"
            textField = field
        }
        present(alert, animated: true, completion: nil)
        
    }
}

