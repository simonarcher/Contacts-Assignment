//
//  ViewController.swift
//  Contacts
//
//  Created by Simon Archer on 2017/07/25.
//  Copyright © 2017 Simon Archer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var contactsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        
        contactsTableView.tableFooterView = UIView()
        
        let voucherCellXib = UINib(nibName: "ContactTableViewCell", bundle: nil)
        contactsTableView.register(voucherCellXib, forCellReuseIdentifier: "ContactCell")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ContactDetailSegue" {
            let destination = segue.destination as! ContactDetailViewController
            destination.detailView = .new
            print("Preparing segue for AddContactSegue")
        }
    }

    @IBAction func addContactButtonPressed(_ sender: UIBarButtonItem) {
        print("addContactButtonPressed")
        
        performSegue(withIdentifier: "ContactDetailSegue", sender: nil)
    }

}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row at \(indexPath.row)")
        contactsTableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contactsTableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactTableViewCell
        cell.nameLabel.text = "test"
        return cell
    }
}
