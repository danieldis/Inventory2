//
//  AddViewController.swift
//  Inventory
//
//  Created by Daniel Salmond on 10/24/18.
//  Copyright © 2018 Daniel Salmond. All rights reserved.
//


protocol AddViewControllerDelgate {
    func addInventoryItem(valueSent: InventoryItem)
}

import UIKit

class AddViewController: UIViewController {
    
    var delegate:AddViewControllerDelgate?
    
    @IBOutlet weak var ShortDescription: UITextField!
    
    @IBOutlet weak var LongDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add New Item"

        let save = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveItem))
        self.navigationItem.rightBarButtonItem = save
    }
    
    @objc func saveItem() {
        let newItem = InventoryItem(shortDescription: ShortDescription.text!, longDescription: LongDescription.text)
        
        delegate?.addInventoryItem(valueSent: newItem)
        self.navigationController?.popViewController(animated: true)
    }

}
