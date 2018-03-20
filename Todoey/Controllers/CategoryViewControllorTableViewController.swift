//
//  CategoryViewControllorTableViewController.swift
//  Todoey
//
//  Created by Udit Kapahi on 19/03/18.
//  Copyright © 2018 Udit Kapahi. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewControllorTableViewController: UITableViewController {
    @IBOutlet var todoeyCategoryTable: UITableView!
    
    let realm = try! Realm()
    
    var categoryArray: Results<Category>?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell",for: indexPath)
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
    

}
