//
//  CategoryViewController.swift
//  CoreDataAPP
//
//  Created by NAZISH ZOHAIB on 27/02/2020.
//  Copyright © 2020 NAZISH ZOHAIB. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController : SwipeTableViewController {
    let realm = try! Realm()
    var categories : Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        // Nil Coalescing OPerator
        return categories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        guard let categoryColor = UIColor(hexString: categories?[indexPath.row].color) else{fatalError()}
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added yet "
        cell.backgroundColor = categoryColor
        
        cell.textLabel?.textColor = ContrastColorOf(backgroundColor: categoryColor, returnFlat: true)
        return cell
        
    }
    //Mark: - Tableview Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    //MARK: - Add new Category
    @IBAction func addButtinPressed(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Categry", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textfield.text!
            newCategory.color = UIColor.randomFlat()?.hexValue() ?? "478FE6"
            
            self.save(category: newCategory)
        }
        alert.addTextField { (field) in
            textfield = field
            textfield.placeholder = " Enter new Category"
        }
        alert.addAction(action)
        present(alert ,animated: true,completion: nil )
        
    }
    //MARK: - Manipulation Methods
    
    //save the Category in the context
    func save(category: Category)  {
        do{
            try   realm.write{
                realm.add(category)
            }
        }catch{
            print("Error in saving to the context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(){
        categories = realm.objects(Category.self)
    }
    
    // Delete data from Swipe
    
    override func updataModel(at indexpath: IndexPath) {
        // super.updataModel(at: indexpath)
        if  let category = self.categories?[indexpath.row]{
            do{
                try   self.realm.write{
                    self.realm.delete(category)
                }
            }catch{
                print("Error in deleting to the context \(error)")
            }
        }
    }
}
