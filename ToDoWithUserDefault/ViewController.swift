//
//  ViewController.swift
//  ToDoWithUserDefault
//
//  Created by Shuihua Zhu on 27/11/18.
//  Copyright © 2018 UMA Mental Arithmetic. All rights reserved.
//

import UIKit
import SwipeCellKit
class ViewController:UIViewController, UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate{
    @IBOutlet weak var tableView: UITableView!
    let defaults = UserDefaults.standard
    let saveKey = "saveKey"
    var items:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        if let items = defaults.array(forKey: saveKey) as? [String]
        {
            self.items = items;
            tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var itemTextField:UITextField!
        let alert = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            itemTextField = textField
            textField.placeholder = "Add New Item"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let str = itemTextField.text!
            self.items.append(str)
            
            self.saveList()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    func saveList()
    {
        self.tableView.reloadData()
        self.defaults.setValue(self.items, forKey: self.saveKey)
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.items.remove(at: indexPath.row)
            self.defaults.setValue(self.items, forKey: self.saveKey)
        }
        deleteAction.image = UIImage(named: "delete-icon")
        return [deleteAction]
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.setEditing(true, animated: true)
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        // to drag drop
        // this function will return .none
        // tableView canMoveAt return true
        // manipulate the underline data
        // tabieView.setEditing all parameters to true.
        return .none
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let tmp = items[destinationIndexPath.row]
        items[destinationIndexPath.row] = items[sourceIndexPath.row]
        items[sourceIndexPath.row] = tmp
        tableView.setEditing(false, animated: true)
        defaults.setValue(items, forKey: saveKey)
    }
}

