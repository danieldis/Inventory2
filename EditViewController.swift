//
//  EditViewController.swift
//  Inventory
//
//  Created by Daniel Salmond on 10/24/18.
//  Copyright © 2018 Daniel Salmond. All rights reserved.
//

protocol EditViewControllerDelgate {
    func updateInventoryItem(valueSent: InventoryItem)
}

import UIKit

class EditViewController: UIViewController {
    
    var delegate:EditViewControllerDelgate?
    
    
   
    @IBOutlet weak var EditShortDescription: UITextField!
    
    
    @IBOutlet weak var EditLongDescription: UITextView!
    
    var edit: Int = 0
    
    var shortDescription = ""
    var longDescription = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Edit Item"

        let save = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveItem))
        self.navigationItem.rightBarButtonItem = save
        // Do any additional setup after loading the view.
        
        EditShortDescription.text = shortDescription
        EditLongDescription.text = longDescription
    }
    
    @objc func saveItem() {
        
        let editItem = InventoryItem(shortDescription: EditShortDescription.text ?? "", longDescription: EditLongDescription.text)
        //delete(Any?.self)
        delegate?.updateInventoryItem(valueSent: editItem)
        self.navigationController?.popViewController(animated: true)
    }

}
