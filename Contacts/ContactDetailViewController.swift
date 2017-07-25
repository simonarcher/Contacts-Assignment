//
//  ContactDetailViewController.swift
//  Contacts
//
//  Created by Simon Archer on 2017/07/25.
//  Copyright © 2017 Simon Archer. All rights reserved.
//

import UIKit
import CoreData

enum DetailView {
    case new
    case edit
    case view
}

class ContactDetailViewController: UIViewController {

    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var detailContainerView: UIView!
    
    var detailView: DetailView = .view
    
    var detailTableView: ContactDetailTableViewController?
    
    var contact: NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let name = contact.value(forKeyPath: "name") as? String {
            detailTableView?.contactNameLabel.text = name
        }
        
        
        
        switch detailView {
        case .new:
            print("New View")
        case .edit:
            print("Edit View")
        case .view:
            print("View View")
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
        }
    }
    
    func editTapped() {
        print("editTapped")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailTableViewSegue" {
            print("DetailTableViewSegue")
            
            detailTableView = segue.destination as? ContactDetailTableViewController
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
