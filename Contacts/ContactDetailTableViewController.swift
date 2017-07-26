//
//  ContactDetailTableViewController.swift
//  Contacts
//
//  Created by Simon Archer on 2017/07/25.
//  Copyright © 2017 Simon Archer. All rights reserved.
//

import UIKit

protocol ContactDetailTableViewControllerDelegate {
    func deleteContact()
}

class ContactDetailTableViewController: UITableViewController {

    @IBOutlet weak var contactNameLabel: UITextField!
    @IBOutlet weak var contactEmailLabel: UITextField!
    @IBOutlet weak var contactPhoneLabel: UITextField!
    @IBOutlet weak var colourTextField: UITextField!
    
    let colourPicker = UIPickerView()
    
    var delegate: ContactDetailTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        
        colourTextField.inputView = colourPicker
        colourPicker.dataSource = self
        colourPicker.delegate = self
        
        colourTextField.tintColor = UIColor.clear
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Delete Contact", message:
            "Are you sure you want to delete this contact?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            self.delegate?.deleteContact()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension ContactDetailTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colours.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return colours[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        colourTextField.text = colours[row]
        colourTextField.setColour()
        
        colourTextField.tintColor = UIColor.clear
    }
}
