//
//  ToDoListViewController.swift
//  CoreDataAPP
//
//  Created by NAZISH ZOHAIB on 19/02/2020.
//  Copyright © 2020 NAZISH ZOHAIB. All rights reserved.
//

import UIKit
import CoreData

class  ToDoListViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
   var itemArray = [Item]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    //   print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist"))
        
        
     
        
    }
   //MARK -TableView Datasource and Delegates
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell" )
        let item = itemArray[indexPath.row]
        cell.textLabel?.text =  item.title
        
        //Ternary Operator
        //value = condition? valueOfTrue : valueOfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
       // itemArray[indexPath.row].done = !itemArray[indexPath.row].done
      saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItems()
            
        }
        alert.addTextField { (alertTextField) in
            textField = alertTextField
        }
        alert.addAction( action)
        present(alert, animated: true, completion: nil)
    }
    //MARK - Model Manuplation Methods
    func saveItems()  {
      
        
            do{
               try  context.save()
            }catch{
              print("Error saving context \(error)")
            }
       
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(),predicate : NSPredicate? = nil ) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name Matches %@",selectedCategory!.name!)
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }

    do{
       itemArray = try context.fetch(request)
    }catch{
        print("Error in fetching data from context, \(error)")
        }
        tableView.reloadData()
    }
}

//MARK: - Search Bar Methods
extension ToDoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        let sortDiscriptors = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDiscriptors]
        loadItems(with: request, predicate: predicate)
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
