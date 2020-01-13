//
//  ViewController.swift
//  Inventory
//
//  Created by Daniel Salmond on 10/21/18.
//  Copyright © 2018 Daniel Salmond. All rights reserved.
//






struct InventoryItem{
    var shortDescription: String
    var longDescription: String
}

import UIKit
import SQLite3

class ViewController: UITableViewController, AddViewControllerDelgate, EditViewControllerDelgate {
    
    
    func updateInventoryItem(valueSent: InventoryItem, index:Int) {
        inventoryItems[index] = valueSent
        tableView.reloadData()
    }
    
    
    func addInventoryItem(valueSent: InventoryItem) {
        inventoryItems.append(valueSent)
        tableView.reloadData()
    }
    
    
    var inventoryItems = [InventoryItem]()
    var db: OpaquePointer?
    var stmt : OpaquePointer?
    
    
    
    
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
        
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Inventory"
        
        //saveToDatabase() when notice of 'about to lose focus' occure
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(saveToDatabase(_:)),
                                       name: UIApplication.willResignActiveNotification,
                                       object: nil)
        
        // set up db
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) .appendingPathComponent("Inventory.sqlite")
        
        // Open database
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print ("error opening database")
        }
        
        // Create Table
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Items (id INTEGER PRIMARY KEY AUTOINCREMENT, shortDescription VARCHAR, longDescription VARCHAR)", nil, nil, nil) != SQLITE_OK {let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
        // Call method
        readValues()
        
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
    
    func readValues(){
        
        // Load var with table information including all columns
        let queryString = "SELECT * FROM Items"
        
        // Open database with alert if failed
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        // Load each row into database
        while(sqlite3_step(stmt) == SQLITE_ROW){
            _ = sqlite3_column_int(stmt, 0)
            let shortDescription = String(cString: sqlite3_column_text(stmt, 1))
            let longDescription = String(cString: sqlite3_column_text(stmt, 2))
            
            inventoryItems.append(InventoryItem(shortDescription: String(describing: shortDescription), longDescription: String(describing: longDescription)))
        }
    }
        
    @objc func saveToDatabase(_ notification:Notification) {
        //insert query string
        let queryString = "INSERT INTO Items (shortDescription, longDescription) VALUES (?,?)"
        
        //Delete table content
        let deleteStatementString = "DELETE FROM Items"
        sqlite3_prepare(db, deleteStatementString, -1, &stmt, nil)
        sqlite3_step(stmt)
        
        for item in inventoryItems {
            //preparing the query
            if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
                return
            }
            
            //binding shortDescription
            if sqlite3_bind_text(stmt, 1, item.shortDescription, -1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding shortDescription: \(errmsg)")
                return
            }
            
            //bind longDescription
            if sqlite3_bind_text(stmt, 2, (item.longDescription as NSString).utf8String, -1, nil) != SQLITE_OK{let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding longDescription: \(errmsg)")
                return
            }
            
            //executing the query to insert values
            if sqlite3_step(stmt) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure inserting item: \(errmsg)")
                return
            }
            
            //Executing the query to insert values
            //if sqlite3_step(stmt) != SQLITE_DONE {
            //    let errmsg = String(cString: sqlite3_errmsg(db)!)
            //    print("failure inserting item: \(errmsg)")
            //    return
            //}
            
            //Print in console upon successful save
            print("Item saved successfully")
            
            //Close database after successful save
            sqlite3_close(stmt)
            
        }
        
    }
    
}














/*
import UIKit
import SQLite3

struct InventoryItem{
    //var id: Int
    var shortDescription: String
    var longDescription: String
}

class ViewController: UITableViewController, AddViewControllerDelgate, EditViewControllerDelgate {
    
    
    var db: OpaquePointer?
    var stmt : OpaquePointer?
    var inventoryItems = [InventoryItem]()
    
    
    @objc func saveToDatabase(_ notification:Notification) {
        //insert query string
        let queryString = "INSERT INTO Items (shortDescription, longDescription) VALIUES (?,?)"
        
        //Delete table content
        let deleteStatementString = "DELETE FROM Items"
        sqlite3_prepare(db, deleteStatementString, -1, &stmt, nil)
        sqlite3_step(stmt)
        
        for item in inventoryItems {
            //preparing the query
            if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("errormpreparing insert: \(errmsg)")
                return
            }
            
            //binding shortDescription
            if sqlite3_bind_text(stmt, 1, item.shortDescription, -1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding shortDescription: \(errmsg)")
                return
            }
            
            //bind longDescription
            if sqlite3_bind_text(stmt, 2, (item.longDescription as NSString).utf8String, -1, nil) != SQLITE_OK{let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding longDescription: \(errmsg)")
                return
            }
            
            //executing the query to insert values
            if sqlite3_step(stmt) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure inserting item: \(errmsg)")
                return
            }
            
            //Executing the query to insert values
            if sqlite3_step(stmt) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure inserting item: \(errmsg)")
                return
            }
            
            //Print in console upon successful save
            print("Item saved successfully")
            
            //Close database after successful save
            sqlite3_close(stmt)
            
        }
        
    }
    
    
    func readValues(){
        
        // Load var with table information including all columns
        let queryString = "SELECT * FROM Items"
        
        // Open database with alert if failed
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        // Load each row into database
        while(sqlite3_step(stmt) == SQLITE_ROW){
            _ = sqlite3_column_int(stmt, 0)
            let shortDescription = String(cString: sqlite3_column_text(stmt, 1))
            let longDescription = String(cString: sqlite3_column_text(stmt, 2))
            
            inventoryItems.append(InventoryItem(shortDescription: String(describing: shortDescription), longDescription: String(describing: longDescription)))
        }
        
        
        /*
        //first empty the list of Items
        inventoryItems.removeAll()
         
        //this is our select query
        let queryString = "SELECT * FROM Inventory"
        
        //Statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let shortDescription = String(cString: sqlite3_column_text(stmt, 1))
            let longDescription = String(cString: sqlite3_column_text(stmt, 2))
            
            //adding values to list
            inventoryItems.append(InventoryItem(id: Int(id), shortDescription: String(shortDescription), longDescription: String(longDescription)))
        }
        
        tableView.reloadData()
        */
    }
    
    
    func updateInventoryItem(valueSent: InventoryItem, index:Int) {
        inventoryItems[index] = valueSent
        tableView.reloadData()
    }
    
    
    func addInventoryItem(valueSent: InventoryItem) {
        inventoryItems.append(valueSent)
        tableView.reloadData()
    }
    
    
    
    
    
    
    
    
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
        
    
        
        self.title = "Inventory"
        
        //saveToDatabase() when notice of 'about to lose focus' occure
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                            selector: #selector(saveToDatabase(_:)),
                                            name: UIApplication.willResignActiveNotification,
                                            object: nil)
        
        // set up db
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) .appendingPathComponent("Inventory.sqlite")
        
        // Open database
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print ("error opening database")
        }
        
        // Create Table
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Items (id INTEGER PRIMARY KEY AUTOINCREMENT,shortDescription VARCHAR, longDescription VARCHAR)", nil, nil, nil) != SQLITE_OK {let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
        // Call method
        readValues()
        
    
        
        /*
        let notificationCenter = NotificationCenter.default; notificationCenter.addObserver(self, selector:#selector(saveToDatabase(_:)), name: UIApplication.willResignActiveNotification)
  
        
        
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
        
        readValues()
        
    }
    */
        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
    
    //@IBOutlet weak var tableViewController: UILabel!
 
    }
    
}
*/

