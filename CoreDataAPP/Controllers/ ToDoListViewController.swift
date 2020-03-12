//
//  ToDoListViewController.swift
//  CoreDataAPP
//
//  Created by NAZISH ZOHAIB on 19/02/2020.
//  Copyright © 2020 NAZISH ZOHAIB. All rights reserved.
//

import UIKit
import RealmSwift

class  ToDoListViewController: UITableViewController {
    var toDoItems : Results<Item>?
    let realm =  try! Realm()
    
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //   print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist"))
        
        
        
        
    }
    //MARK -TableView Datasource and Delegates
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell" )
        if  let item = toDoItems?[indexPath.row]{
            cell.textLabel?.text =  item.title
            
            //Ternary Operator
            //value = condition? valueOfTrue : valueOfFalse
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text  = "No Items Added"
        }
        return cell
    }
    //MARK: -TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let item = toDoItems?[indexPath.row]{
            do{
                
              try realm.write{
                item.done = !item.done
            //    realm.delete(item)
                             }
             }
                catch{
                  print("Error in saving done status\(error)")
                }
        }
     
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    //MARK: -Add New Items
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default)
        { (action) in
            //what will happen once the user click Add Item button on our UIAlert
            if let currentCategory = self.selectedCategory{
                
                do{
                    try   self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("error saving new items\(error)")
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            textField = alertTextField
        }
        alert.addAction( action)
        present(alert, animated: true, completion: nil)
    }
    //MARK - Model Manuplation Methods
    
    
    func loadItems() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
}

//MARK: - Search Bar Methods
extension ToDoListViewController: UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: false)
        tableView.reloadData()
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
