//
//  CategoryTableViewController.swift
//  Todo List
//
//  Created by Rizwan on 1/10/19.
//  Copyright © 2019 Course. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryTableViewController: UITableViewController {

    
    let realm = try! Realm()
    var categoryArray : Results<CategoryData>?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataValues()
    }

    //MARK: Data Manipulation Method
    
    func saveDataValue(category : CategoryData) {
        //Core Data
//        do {
//            try context.save()
//        } catch {
//            print(error)
//        }
//        tableView.reloadData()
        
        //Realm
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadDataValues() {
        //Core Data
//        do {
//            categoryArray = try context.fetch(request)
//        } catch  {
//            print(error)
//        }
//        tableView.reloadData()
        
        //Realm
        
        let categories = realm.objects(CategoryData.self)
        categoryArray = categories
        tableView.reloadData()
        
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        categoryCell.textLabel?.text = categoryArray?[indexPath.row].categoryName ?? "No Caategories Added"
        return categoryCell
    }
    
    //MARK: - Table Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            if let destinationVC = segue.destination as? TodoListVC {
                if let selectedIndex = tableView.indexPathForSelectedRow {
                    destinationVC.selectedCategory = categoryArray?[selectedIndex.row]
                }
            }
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
//            let categoryItem = Category(context: self.context)
//            categoryItem.categoryName = alertTextField.text!
//            self.categoryArray.append(categoryItem)
            let newCat = CategoryData()
            newCat.categoryName = alertTextField.text!
            self.saveDataValue(category: newCat)
        }
        alert.addTextField { (textField) in
            alertTextField = textField
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension CategoryTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        request.predicate = NSPredicate(format: "categoryName CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "categoryName", ascending: true)]
        loadDataValues()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadDataValues()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadDataValues()
    }
}
