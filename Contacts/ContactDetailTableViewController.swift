//
//  ContactDetailTableViewController.swift
//  Contacts
//
//  Created by Simon Archer on 2017/07/25.
//  Copyright © 2017 Simon Archer. All rights reserved.
//

import UIKit

class ContactDetailTableViewController: UITableViewController {

    @IBOutlet weak var contactNameLabel: UITextField!
    @IBOutlet weak var contactUsernameLabel: UITextField!
    @IBOutlet weak var contactEmailLabel: UITextField!
    @IBOutlet weak var contactPhoneLabel: UITextField!
    @IBOutlet weak var contactWebsiteLabel: UITextField!
    
    @IBOutlet weak var streetLabel: UITextField!
    @IBOutlet weak var suiteLabel: UITextField!
    @IBOutlet weak var cityLabel: UITextField!
    @IBOutlet weak var zipcodeLabel: UITextField!
    
    @IBOutlet weak var companyLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        print("deleteButtonTapped")
    }
    
}
