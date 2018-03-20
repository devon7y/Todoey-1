//
//  ViewController.swift
//  Todoey
//
//  Created by Udit Kapahi on 15/03/18.
//  Copyright © 2018 Udit Kapahi. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController{
    
    var itemArray = [Item]()
    var selectedCategory:Category?{
        didSet{
            // we will load items here when the value of category is set 
            loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var todoeyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //        todoeyTableView.delegate = self
        //        todoeyTableView.dataSource = self
        //        todoeyTableView.register(UINib(nibName:"TodoeyCell",bundle:nil), forCellReuseIdentifier: "todoeyCell")
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //        if let items = UserDefaults.standard.array(forKey: "ToDoListArray") as? [Item]{
        //            itemArray = items
        //        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    MARK : tableview datasource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = UITableViewCell(style: .default, reuseIdentifier: "TodoItemCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //    MARK: Table view Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.cellForRow(at: indexPath)?.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        //        for update operations you can use the following statement as well but us still need to call context.save
        //        itemArray[indexPath.row].setValue("My value to be set on update", forKey: "title")
        
        //        to delete use following statement
        //        context.delete(itemArray[indexPath.row]) // removes item from context and should be called first before deleting the same data from the row to avoaid exceptions indexo
        //        itemArray.remove(at: indexPath.row)  // removes items from the item array to refresh the data
        
        self.saveItems()
        tableView.deselectRow(at: indexPath , animated: true)
    }
    
    // MARK : BUTTON PRESS EVENT
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoey Item", message:  "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (acttion) in
            // What will happen when user presses the add item button on alert
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            // AddData to defaults persitent storage
            //            self.defaults.set(self.itemArray, forKey: "ToDoListArray") ///Since we are trying to save data of item type , the app will crash, becasue defaults are meant to store predefined data types not the custom one so we will use NScoder
            
            self.saveItems()
            
        }
        
        //for adding a textfeild
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Model Manipulation
    func saveItems(){
        //        this function is called everytime u are making changes in data
        do{
            try context.save()
        }catch {
            print("Error saving context \(error)")
        }
        
        self.todoeyTableView.reloadData()
    }
    
    func loadItems(with requestParams:NSFetchRequest<Item> = Item.fetchRequest(),predicate: NSPredicate? = nil){
//         requestParams:NSFetchRequest<Item> = Item.fetchRequest() using = Item.FetchRequest allows function to take default values if not passed upon calling
//        so if we call this method without request params it will take Item.fetchRequest as default
//        this method has 1 . external parameter using with, 2. internal parameter 3. with a default value
//        in order to load items related to a specific category we need to filter the items , therefore we NEED TO CREATE A NSPREDICATE
        let categoryPredicate = NSPredicate(format: "parentCategory.attribute MATCHES %@", selectedCategory!.attribute!)
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate!])
//        requestParams.predicate = compoundPredicate
        if let additionalPredicate = predicate {
            requestParams.predicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else{
            requestParams.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(requestParams)
            
        }catch{
            print("error fetching data \(error)")
        }
        tableView.reloadData()
    }
}

//MARK: Search bar methods
extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
//        now we are going to QUERY THE REQUEST
//        cd makes the query insensitive
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request,predicate: predicate)
        print(searchBar.text!)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                // to remove keyboard on the main thread when the typed word is nill
                searchBar.resignFirstResponder()
            }
            
        }else{
            let request: NSFetchRequest<Item> = Item.fetchRequest()
            
            //        now we are going to QUERY THE REQUEST
            //        cd makes the query insensitive
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            loadItems(with: request, predicate: predicate)
            print(searchBar.text!)
        }
        
    }
}

