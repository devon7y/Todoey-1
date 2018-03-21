//
//  CategoryViewControllorTableViewController.swift
//  Todoey
//
//  Created by Udit Kapahi on 19/03/18.
//  Copyright © 2018 Udit Kapahi. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewControllorTableViewController: UITableViewController {
    @IBOutlet var todoeyCategoryTable: UITableView!
    
    let realm = try! Realm()
    
    var categoryArray: Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todoeyCategoryTable.rowHeight = 80
        loadCategories()
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController.init(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.attribute = textField.text!
            //            since categoryArray is of result type ,realm is going to auto update it so no need to append
            //            self.categoryArray.append(newCategory)
            self.saveItems(category: newCategory)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter category name"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Tabel view data source methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell",for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = categoryArray?[indexPath.row].attribute ?? "No Categories added yet"
        cell.delegate = self
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    //MARK : table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! TodoListViewController
        if let indexPath = self.todoeyCategoryTable.indexPathForSelectedRow{
            destinationViewController.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    //MARK : Daqtamanipulation maethods
    func saveItems(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch {
            print("Error saving context \(error)")
        }
        self.todoeyCategoryTable.reloadData()
    }
    
    func loadCategories(){
        categoryArray = realm.objects(Category.self)
    }
    
}

//MARK: Swipe cell delegat methods
extension  CategoryViewControllorTableViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            if let category = self.categoryArray?[indexPath.row] {
                do{
                    try self.realm.write {
                        for item in category.items {
                            self. realm.delete(item)  //remove all child items. But app crashes
                        }
                        self.realm.delete(category)

                    }
                }catch {
                    print("Error Deleteing data \(error)")
                }
            }
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    
    //MARK: customise swipe options here
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
}
