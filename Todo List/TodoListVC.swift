//
//  ViewController.swift
//  Todo List
//
//  Created by Rizwan on 1/8/19.
//  Copyright © 2019 Course. All rights reserved.
//

import UIKit

class TodoListVC: UITableViewController {

    let itemsArray = ["Find Hike", "Buy Eggs", "Hire Drivers"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
}

