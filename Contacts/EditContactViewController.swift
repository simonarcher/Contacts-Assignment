//
//  EditContactViewController.swift
//  Contacts
//
//  Created by Simon Archer on 2017/07/25.
//  Copyright © 2017 Simon Archer. All rights reserved.
//

import UIKit
import CoreData

class EditContactViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    var editTableView: EditContactTableViewController?
    
    var contacts: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        editTableView?.nameTextField.becomeFirstResponder()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditContactTableViewSegue" {
            editTableView = segue.destination as? EditContactTableViewController
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        print("Save data")
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity = NSEntityDescription.entity(forEntityName: "Contact", in: managedContext)!
        
        let contact = NSManagedObject(entity: entity, insertInto: managedContext)
        
        if let name = editTableView?.nameTextField.text {
            print("Save name - \(name)")
            // 3
            contact.setValue(name, forKeyPath: "name")
        }
        
        
        
        // 4
        do {
            try managedContext.save()
            contacts.append(contact)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        
        self.dismiss(animated: true, completion: nil)
    }

}
