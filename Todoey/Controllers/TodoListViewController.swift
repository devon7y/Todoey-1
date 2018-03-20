//
//  ViewController.swift
//  Todoey
//
//  Created by Udit Kapahi on 15/03/18.
//  Copyright © 2018 Udit Kapahi. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController{
    let realm = try! Realm()
    var itemResults: Results<Item>?
    var selectedCategory:Category?{
        didSet{
            // we will load items here when the value of category is set 
            loadItems()
        }
    }
    
    // MARK : BUTTON PRESS EVENT
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoey Item", message:  "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (acttion) in
            // What will happen when user presses the add item button on alert
            if let currentCategory = self.selectedCategory {
                let newItem = Item()
                do{
                    try self.realm.write {
                        newItem.title = textField.text!
                        newItem.done = false
                        currentCategory.items.append(newItem)
                        self.todoeyTableView.reloadData()
                    }
                }catch{
                    print("Error saving new item \(error)")
                }
                
            }
            
        }
        
        //for adding a textfeild
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    @IBOutlet var todoeyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    MARK : tableview datasource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        if let item = itemResults?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No items added yet"
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemResults?.count ?? 1
    }
    
    
    //    MARK: Table view Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        UPDATE DATA HERE
        if let item = itemResults?[indexPath.row]{
            do {
                try realm.write {
                    item.done = !item.done
                }
            }catch{
                print("Error updating done status \(error)")
            }
            
            tableView.cellForRow(at: indexPath)?.accessoryType = item.done ? .checkmark : .none
            tableView.deselectRow(at: indexPath , animated: true)
            tableView.reloadData()
        }
        
    }
    //MARK - Model Manipulation
    
    func loadItems(){
        itemResults = selectedCategory?.items.sorted(byKeyPath: "title",ascending: true)
        tableView.reloadData()
    }
}
//MARK: Search bar methods
//extension TodoListViewController: UISearchBarDelegate{
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
////        now we are going to QUERY THE REQUEST
////        cd makes the query insensitive
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        loadItems(with: request,predicate: predicate)
//        print(searchBar.text!)
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems()
//            DispatchQueue.main.async {
//                // to remove keyboard on the main thread when the typed word is nill
//                searchBar.resignFirstResponder()
//            }
//
//        }else{
//            let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//            //        now we are going to QUERY THE REQUEST
//            //        cd makes the query insensitive
//            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//            loadItems(with: request, predicate: predicate)
//            print(searchBar.text!)
//        }
//
//    }
//}
//
