//
//  CategoryViewControllorTableViewController.swift
//  Todoey
//
//  Created by Udit Kapahi on 19/03/18.
//  Copyright © 2018 Udit Kapahi. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewControllorTableViewController: UITableViewController {
    @IBOutlet var todoeyCategoryTable: UITableView!
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

   
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController.init(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Add", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.attribute = textField.text!
            self.categoryArray.append(newCategory)
            self.saveItems()
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
        cell.textLabel?.text = categoryArray[indexPath.row].attribute
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    //MARK : table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! TodoListViewController
        if let indexPath = self.todoeyCategoryTable.indexPathForSelectedRow{
            destinationViewController.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK : Daqtamanipulation maethods
    func saveItems(){
        do{
            try context.save()
        }catch {
            print("Error saving context \(error)")
        }
        self.todoeyCategoryTable.reloadData()
    }
    
    func loadCategories(with requestParams:NSFetchRequest<Category> = Category.fetchRequest()){
        do {
            categoryArray = try context.fetch(requestParams)
            self.todoeyCategoryTable.reloadData()
        }catch{
            print("error fetching data \(error)")
        }
    }
    

}
