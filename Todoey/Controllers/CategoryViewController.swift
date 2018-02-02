//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Valery Silin on 02/02/2018.
//  Copyright © 2018 Valery Silin. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var category = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    
    }
 
    // MARK: - TableView Datasource and Delegate Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return category.count
    
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = category[indexPath.row].name
        
        return cell
   
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = category[indexPath.row]
        }
    }
    
    // MARK: - Data Manipulation Methods
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Unable to save context \(error)")
        }
        tableView.reloadData()
    }
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
     
        do {
          category = try context.fetch(Category.fetchRequest())
        } catch  {
            print("Error fetching request \(error)")
        }
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let categoryName = category[indexPath.row]
        context.delete(categoryName)
        category.remove(at: indexPath.row)
        saveCategories()
        tableView.reloadData()

    }
    // MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.category.append(newCategory)
            self.saveCategories()
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            field.placeholder = "Create a new category"
            textField = field
        }
        present(alert, animated: true, completion: nil)
    }

}
