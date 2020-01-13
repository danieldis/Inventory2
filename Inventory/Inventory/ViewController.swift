//
//  ViewController.swift
//  Inventory
//
//  Created by Daniel Salmond on 10/21/18.
//  Copyright © 2018 Daniel Salmond. All rights reserved.
//

import UIKit
import SQLite3

struct InventoryItem{
    var shortDescription: String
    var longDescription: String
}

import UIKit

class ViewController: UITableViewController, AddViewControllerDelgate, EditViewControllerDelgate {
    
    var db: OpaquePointer?
    
    @objc func saveToDatabase(_ notification:Notification) {
        
        //open SQLite3 database
        
        //execute the SQL statment "DELETE FROM Items"
        
        //For each item in the itmes[] array
            //call sqlite3_prepare() to prepare the INSERT SQL statement string
            //call sqlite3_bind_text() to bind the shortDescription and longDescription feilds
            //call sqlite3_step() to execute the "INSERT INTO Items" to add each item to the database Items table.
        //Close thje database with sqlite3_close()
        
        
    }
    
    
    func updateInventoryItem(valueSent: InventoryItem, index:Int) {
        inventoryItems[index] = valueSent
        tableView.reloadData()
    }
    
    
    func addInventoryItem(valueSent: InventoryItem) {
        inventoryItems.append(valueSent)
        tableView.reloadData()
    }
    
    
    var inventoryItems = [InventoryItem]()
    
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return inventoryItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = inventoryItems[indexPath.row].shortDescription
        cell.detailTextLabel?.text = inventoryItems[indexPath.row].longDescription
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            inventoryItems.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let notificationCenter = NotificationCenter.default; notificationCenter.addObserver(self, selector:#selector(saveToDatabase(_:)), object: nil)
        
        //the database file
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Inventory.sqlite")
        
        //opening the database
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        //creating table
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Items (id INTEGER PRIMARY KEY AUTOINCREMENT, shortDescription: VARCHAR, longDescription: VARCHAR)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Inventory"
        
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if (segue.identifier == "addSegue") {
                let view = segue.destination as! AddViewController
                view.delegate = self
            }
        
            if segue.identifier=="editSegue" {
                let view = segue.destination as! EditViewController
                view.delegate = self
                view.updateInventoryItem = tableView.indexPathForSelectedRow?.row ?? 0
                view.shortDescription = inventoryItems[tableView.indexPathForSelectedRow?.row ?? 0].shortDescription
                view.longDescription = inventoryItems[tableView.indexPathForSelectedRow?.row ?? 0].longDescription
                
            }
        }
    
    @IBOutlet weak var tableViewController: UILabel!
    
}


