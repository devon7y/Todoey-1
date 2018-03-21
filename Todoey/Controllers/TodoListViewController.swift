//
//  ViewController.swift
//  Todoey
//
//  Created by Udit Kapahi on 15/03/18.
//  Copyright © 2018 Udit Kapahi. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController{
    let realm = try! Realm()
    var itemResults: Results<Item>?
    var selectedCategory:Category?{
        didSet{
            // we will load items here w    hen the value of category is set
            loadItems()
        }
    }
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let colorHex = selectedCategory?.color else { fatalError()}
            title = selectedCategory?.attribute
        updateNavBar(withHexCode: colorHex)
    }
    
    //
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "9537FF")
    }
    
    //    MARK: UPDATE NAV BAR METHOD
    func updateNavBar(withHexCode colorHexCode:String){
        guard let navBar = navigationController?.navigationBar else { fatalError("NAvigation controller not exist.")}
        guard let navBarColor = UIColor(hexString: colorHexCode) else {fatalError()}
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        searchBar.barTintColor = navBarColor
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
    
    
    
    //    MARK : tableview datasource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = itemResults?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            if let color = UIColor(hexString:selectedCategory!.color)?.darken(byPercentage: CGFloat(CGFloat(indexPath.row)/CGFloat(itemResults!.count))){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
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
                    //                    TO DELETE AN ITEM SIMPLY UNCOMMENT FOLLOEINF STATEMENT
                    //                    realm.delete(item)
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
    
    //MARK: DELETE DATA from swipe
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.itemResults?[indexPath.row] {
            do{
                try self.realm.write {
                    self.realm.delete(item)
                }
            }catch {
                print("Error Deleteing data \(error)")
            }
        }
    }
}
//MARK: Search bar methods
extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemResults = itemResults?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title",ascending:true)
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
            itemResults = itemResults?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date",ascending:true)
            self.todoeyTableView.reloadData()
            print(searchBar.text!)
        }
        
    }
}


