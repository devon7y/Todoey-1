//
//  CategoryViewControllorTableViewController.swift
//  Todoey
//
//  Created by Udit Kapahi on 19/03/18.
//  Copyright © 2018 Udit Kapahi. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewControllorTableViewController: SwipeTableViewController {
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
        //        the following line will be tapping int o cell view defined in swipetableviewcontroller calss
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].attribute ?? "No Categories added yet"
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
    
    //MARK: DELETE DATA from swipe
    override func updateModel(at indexPath: IndexPath) {
//        to execute the code in the super class method first u need to call
        super.updateModel(at: indexPath)
//       after above execution following code is going to get exceuted
        if let category = self.categoryArray?[indexPath.row] {
            do{
                try self.realm.write {
                    for item in category.items {
                        self.realm.delete(item)  //remove all child items. But app crashes
                    }
                    self.realm.delete(category)
                    
                }
            }catch {
                print("Error Deleteing data \(error)")
            }
        }
    }
    
}

