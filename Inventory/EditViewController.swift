//
//  EditViewController.swift
//  Inventory
//
//  Created by Daniel Salmond on 10/24/18.
//  Copyright © 2018 Daniel Salmond. All rights reserved.
//

protocol EditViewControllerDelgate {
    func updateInventoryItem(valueSent: InventoryItem, index: Int)
}

import UIKit

class EditViewController: UIViewController {
    
    var delegate:EditViewControllerDelgate?
    
   
    @IBOutlet weak var EditShortDescription: UITextField!
    @IBOutlet weak var EditLongDescription: UITextView!
    
    var edit: Int = 0
    
    var updateInventoryItem: Int!
    
    var shortDescription = ""
    var longDescription = ""
    var indexToUpdate = Int.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Edit Item"

        let save = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveItem))
        self.navigationItem.rightBarButtonItem = save
        
        EditShortDescription.text = shortDescription
        EditLongDescription.text = longDescription
    }
    
    @objc func saveItem() {
        
        let editItem = InventoryItem(shortDescription: EditShortDescription.text ?? "", longDescription: EditLongDescription.text)
        self.delegate?.updateInventoryItem(valueSent: editItem, index: updateInventoryItem)
        self.navigationController?.popViewController(animated: true)
        
        self.navigationController?.popViewController(animated: true)
    }
}
