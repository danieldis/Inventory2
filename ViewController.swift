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

class ViewController: UITableViewController, AddViewControllerDelgate, EditViewControllerDelgate {
    
    var inventoryItems = [InventoryItem]()
    
    func addInventoryItem(valueSent: InventoryItem) {
        inventoryItems.append(valueSent)
        tableView.reloadData()
    }
    
    func updateInventoryItem(valueSent: InventoryItem) {
        //inventoryItems.removeAll()
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
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Inventory"
        
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if (segue.identifier == "addSegue") {
                let view = segue.destination as! AddViewController
                view.delegate = self
            }
        
            if(segue.identifier=="editSegue"){
                let view = segue.destination as! EditViewController
                view.delegate = self
                view.shortDescription = inventoryItems[tableView.indexPathForSelectedRow?.row ?? 0].shortDescription
                view.longDescription = inventoryItems[tableView.indexPathForSelectedRow?.row ?? 0].longDescription
                //view.
            }
        }
    
    @IBOutlet weak var tableViewController: UILabel!
    
}


