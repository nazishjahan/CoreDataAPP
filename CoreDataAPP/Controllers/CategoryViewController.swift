//
//  CategoryViewController.swift
//  CoreDataAPP
//
//  Created by NAZISH ZOHAIB on 27/02/2020.
//  Copyright © 2020 NAZISH ZOHAIB. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
   loadCategories()
    }

    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell =  tableView.dequeueReusableCell(withIdentifier: "GoToItem", for: indexPath)
        let category  = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
        
    }
      //Mark: - Tableview Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
        destinationVC.selectedCategory = categoryArray[indexPath.row]
     }
    }
    //MARK: - Add new Category
    @IBAction func addButtinPressed(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Categry", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textfield.text
            self.categoryArray.append(newCategory)
             self.saveCategory()
        }
        alert.addTextField { (field) in
            textfield = field
            textfield.placeholder = " Enter new Category"
        }
        alert.addAction(action)
        present(alert ,animated: true,completion: nil )
        //loadCategories
    }
//MARK: - Manipulation Methods
    
    //save the Category in the comtext
    func saveCategory()  {
        do{
      try  context.save()
        }catch{
            print("Error in saving to the context \(error)")
        }
        tableView.reloadData()
    }
    
    
    // Load the categories from the context

func loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest()){
    do{
   try categoryArray = context.fetch(request)
    }catch{
        print("Error in loading the categories from context \(error)")
    }
    tableView.reloadData()
 }
}
