//
//  ViewController.swift
//  Todo List
//
//  Created by Rizwan on 1/8/19.
//  Copyright © 2019 Course. All rights reserved.
//

import UIKit

class TodoListVC: UITableViewController {

    var itemsArray = [TodoListModel]()
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    var isDefault: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        setNeedsStatusBarAppearanceUpdate()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
    override func setNeedsStatusBarAppearanceUpdate() {
        //preferredStatusBarStyle = .default
    }
    
    func saveItemsMethod() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.itemsArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemsArray = try decoder.decode([TodoListModel].self, from: data)
            } catch {
                print(error)
            }
            
        }
    }
    //MARK: - TableView Data Source Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let todoCell = UITableViewCell(style: .default, reuseIdentifier: "TodoItemCell")
        let todoCell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = itemsArray[indexPath.row]
        todoCell.accessoryType = item.itemSelected ? .checkmark : .none
        todoCell.textLabel?.text = item.itemName
        return todoCell
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemsArray[indexPath.row].itemSelected = !itemsArray[indexPath.row].itemSelected
        tableView.reloadRows(at: [indexPath], with: .fade)
        tableView.deselectRow(at: indexPath, animated: true)
        saveItemsMethod()
    }
    
    //MARK: - Add New Items Sections
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let item = TodoListModel()
            item.itemName = alertTextField.text!
            self.itemsArray.append(item)
            self.saveItemsMethod()
        }
        alert.addTextField { (textField) in
            textField.placeholder = "New Item"
            alertTextField = textField
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}

