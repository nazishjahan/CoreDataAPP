//
//  ToDoListViewController.swift
//  CoreDataAPP
//
//  Created by NAZISH ZOHAIB on 19/02/2020.
//  Copyright © 2020 NAZISH ZOHAIB. All rights reserved.
//

import UIKit

class  ToDoListViewController: UITableViewController,Encodable {
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
   var itemArray = [Item]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        
      loadItems()
        
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
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
      saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = textField.text!
            
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
      let encoder = PropertyListEncoder()
        if let data = try? encoder.encode(itemArray){
            do{
               try data.write(to: dataFilePath!)
            }catch{
                print("Error encoding data \(error)")
            }
        }
        self.tableView.reloadData()
    }
    
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
               try itemArray = decoder.decode([Item].self, from: data)
            }catch{
                print("Error decoding data \(error)")
            }
        }
    }
}

