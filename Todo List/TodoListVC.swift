//
//  ViewController.swift
//  Todo List
//
//  Created by Rizwan on 1/8/19.
//  Copyright © 2019 Course. All rights reserved.
//

import UIKit

class TodoListVC: UITableViewController {

    var itemsArray = ["Find Hike", "Buy Eggs", "Hire Drivers"]
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        if let arrayStored = defaults.value(forKey: "ItemArray") as? [String] {
            itemsArray = arrayStored
        }
    }

    //MARK: - TableView Data Source Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todoCell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        todoCell.textLabel?.text = itemsArray[indexPath.row]
        return todoCell
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items Sections
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            self.itemsArray.append(alertTextField.text ?? "New Item")
            self.defaults.set(self.itemsArray, forKey: "ItemArray")
            self.tableView.reloadData()
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

