//
//  ViewController.swift
//  Todo List
//
//  Created by Rizwan on 1/8/19.
//  Copyright © 2019 Course. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class TodoListVC: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    let realm = try! Realm()
    var itemsArray : Results<RealmItem>?
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var isDefault: Bool = false
    var selectedCategory : CategoryData? {
        didSet {
            loadItems()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
    override func setNeedsStatusBarAppearanceUpdate() {
        //preferredStatusBarStyle = .default
    }
    
    // Mark: - Manipulation Methods
    
    func saveItemsMethod(newItem : RealmItem) {
        //Encodable
//        let encoder = PropertyListEncoder()
//        do {
//            let data = try encoder.encode(self.itemsArray)
//            try data.write(to: self.dataFilePath!)
//        } catch {
//            print(error)
//        }
//        tableView.reloadData()
        
        //CoreData
        
//        do {
//            try context.save()
//        } catch  {
//            print(error)
//        }
//        tableView.reloadData()
        
        //Realm
        
        do {
            try realm.write {
                realm.add(newItem)
            }
        } catch {
            print(error)
        }
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
        //Encodable
//        if let data = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//            do {
//                itemsArray = try decoder.decode([TodoListModel].self, from: data)
//            } catch {
//                print(error)
//            }
//
//        }
        
//        //Core Data
//        let parentPredicate = NSPredicate(format: "parentCategory.categoryName MATCHES %@", selectedCategory!.categoryName!)
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate,parentPredicate])
//        } else {
//            request.predicate = parentPredicate
//        }
//        do {
//            itemsArray = try context.fetch(request)
//        } catch {
//            print(error)
//        }
//        tableView.reloadData()
        
        //Realm
        itemsArray = selectedCategory?.catItems.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    
    //MARK: - TableView Data Source Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todoCell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        if let item = itemsArray?[indexPath.row] {
            todoCell.accessoryType = item.itemSelected ? .checkmark : .none
            todoCell.textLabel?.text = item.itemName
        } else {
            todoCell.textLabel?.text = "No List"
        }
        return todoCell
    }
    
    //MARK: - Tableview Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        itemsArray?[indexPath.row].itemSelected = !itemsArray?[indexPath.row].itemSelected ?? false
        tableView.deselectRow(at: indexPath, animated: true)
        //saveItemsMethonewItem: <#RealmItem#>d()
        if let item = itemsArray?[indexPath.row] {
            do {
                try realm.write {
                    item.itemSelected = !item.itemSelected
                }
            } catch {
                print(error)
            }
        }
        tableView.reloadData()
    }
    
    //MARK: - Add New Items Sections
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
//            let item = Item(context: self.context)
//            item.itemName = alertTextField.text!
//            item.itemSelected = false
//            item.parentCategory = self.selectedCategory
//            self.itemsArray.append(item)
            
            let newItem = RealmItem()
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        newItem.itemName = alertTextField.text!
                        newItem.itemSelected = false
                        newItem.dateCreated = Date()
                        currentCategory.catItems.append(newItem)
                    }
                } catch {
                    print(error)
                }
            }
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

//MARK: - Search Bar Methods
extension TodoListVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//         let predicate = NSPredicate.init(format: "itemName CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "itemName", ascending: true)]
//        loadItems(with: request, predicate: predicate)
        
        itemsArray = itemsArray?.filter("itemName CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
       tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadItems()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
               searchBar.resignFirstResponder()
            }
        }
    }
}
