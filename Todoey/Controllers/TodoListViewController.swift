//
//  ViewController.swift
//  Todoey
//
//  Created by Valeria Heikkila
//

import UIKit
import CoreData
import RealmSwift

class TodoListViewController: SwipeTableViewController {

    //var itemArray = [Item]() //Core Data
    var todoItems : Results<Item>? //Realm
    var selectedCategory : Category? {
        didSet{
            //loadData() //Core Data
            loadItems()
        }
    }
    
    let realm =  try! Realm() //Realm
    
    //object for core data
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //Core Data
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 70.0
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
//MARK:  TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        // Realm
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            //Ternary operator ==> is used instead of long if operator
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        //Core Data
//        let item = todoItems?[indexPath.row]
//        cell.textLabel?.text = item.title
//
//        //Ternary operator ==> is used instead of long if operator
//        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
//MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Realm
        //change value of done to display or hide checkmark
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    //delete from cloud
                    //realm.delete(item)
                    item.done = !item.done
                }
            } catch {
                print(error)
            }
        }
                
        //Core Data
        //change value of done to display or hide checkmark
//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
        
        //delete selected item from the screen and from the db
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        //commit db
        //commit() //Core Data
        
        //make the selected row's color white(unselected)
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        
    }
    
    //Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add button on UIAlert
            
            //Realm
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                }
                } catch{
                    print(error)
                }
            }
       
            //Core Data
//            let newItem = Item(context: self.context)
//            newItem.title = textField.text!
//            newItem.done = false
//            newItem.parentCategory = self.selectedCategory
//            self.itemArray.append(newItem)
            //self.commit()  //Core Data
            
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
//MARK: DB Methods
    
    //Core Data
//    func commit() {
//        do{
//            try context.save()
//        }catch{
//           print(error)
//        }
//    }
    
    //set default value to request so it would be possible to call loadData() without passing a parameter
    
    //Realm
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    //delete item
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDelete = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(itemForDelete)
                }
            }catch {
                print(error)
            }
        }
    }
    
    //Core Data
//    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
//
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//        do{
//            itemArray = try context.fetch(request)
//        }catch{
//            print(error)
//        }
//        //update tableView with current itemArray
//        tableView.reloadData()
//    }
}
//MARK: Search bar Methods

//Realm
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()        
            //make search bar go the original state
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

//Core Data
//extension TodoListViewController: UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        loadData(with: request, predicate: predicate)
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadData()
//
//            //make search bar go the original state
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//}

