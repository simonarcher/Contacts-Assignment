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
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Contact", in: managedContext)!
        
        let contact = NSManagedObject(entity: entity, insertInto: managedContext)
        
        if let name = editTableView?.nameTextField.text {
            print("Save name - \(name)")
            contact.setValue(name, forKeyPath: "name")
        }
        if let username = editTableView?.usernameTextField.text {
            print("Save username - \(username)")
            contact.setValue(username, forKeyPath: "username")
        }
        if let email = editTableView?.emailTextField.text {
            print("Save email - \(email)")
            contact.setValue(email, forKeyPath: "email")
        }
        if let phone = editTableView?.phoneTextField.text {
            print("Save phone - \(phone)")
            contact.setValue(phone, forKeyPath: "phone")
        }
        if let website = editTableView?.websiteTextField.text {
            print("Save website - \(website)")
            contact.setValue(website, forKeyPath: "website")
        }
        
        if let companyName = editTableView?.companyNameTextField.text {
            print("Save companyName - \(companyName)")
            contact.setValue(companyName, forKeyPath: "companyName")
        }
        
        if let street = editTableView?.streetTextField.text {
            print("Save street - \(street)")
            contact.setValue(street, forKeyPath: "street")
        }
        if let suite = editTableView?.suiteTextField.text {
            print("Save suite - \(suite)")
            contact.setValue(suite, forKeyPath: "suite")
        }
        if let city = editTableView?.cityTextField.text {
            print("Save city - \(city)")
            contact.setValue(city, forKeyPath: "city")
        }
        if let zipcode = editTableView?.zipcodeTextField.text {
            print("Save zipcode - \(zipcode)")
            contact.setValue(zipcode, forKeyPath: "zipcode")
        }
        
        do {
            try managedContext.save()
            contacts.append(contact)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
