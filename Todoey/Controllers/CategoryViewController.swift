//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Valeria Heikkila on 2020/10/10.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
    //Realm
    let realm =  try! Realm()
    var categories : Results<Category>?
    
    //Core Data
    //var categories = [Category]()
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //change height of row
        tableView.rowHeight = 80.0
        
        loadCategories()

    }
    
    //MARK: - TableView Datasource Methods
    //display all the categories
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //Realm
        // Nil Coalescing Operator
        // if categories is not nil then unwrapp and return the number of categories, if it is nil then return 1
        return categories?.count ?? 1
        
        //Core Data
        //return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //cell from superclass(already swipable)
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        //Realm
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        //Core Data
        //cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
    
    
    //MARK: - Data Manipilation Methods
    
    //Core Data
    //save data load data
//    func commit() {
//        do{
//            try context.save()
//        }catch{
//           print(error)
//        }
//        tableView.reloadData()
//    }
    
    //Realm
    //save category
    func save(category: Category) {
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
           print(error)
        }
        tableView.reloadData()
    }
    
    //delete category
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDelete = categories?[indexPath.row] {
            do{
                try realm.write {
                    realm.delete(categoryForDelete)
                }
            }catch{
               print(error)
            }
        }
    }
    
    func loadCategories(){
        //Realm
        categories = realm.objects(Category.self)
        tableView.reloadData()
        
        //Core Data
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//        do{
//            categories = try context.fetch(request)
//        }catch{
//            print(error)
//        }
//        //update tableView with current category
//        tableView.reloadData()
    }

    //MARK: - Add new categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //what will happen once the user clicks the Add button on UIAlert
            //let newCategory = Category(context: self.context) // CoreData
            let newCategory = Category() //Realm
            newCategory.name = textField.text!
            //self.categories.append(newCategory) //Core Data
            //self.commit() //CoreData
            self.save(category: newCategory) //Realm
            self.tableView.reloadData()
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Create new category"
        }
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    //before performing Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
            
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
}
