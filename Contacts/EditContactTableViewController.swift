//
//  EditContactTableViewController.swift
//  Contacts
//
//  Created by Simon Archer on 2017/07/25.
//  Copyright © 2017 Simon Archer. All rights reserved.
//

import UIKit

class EditContactTableViewController: UITableViewController {

    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var colourTextField: UITextField!
    
    var colourPicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        contactImageView.isUserInteractionEnabled = true
        contactImageView.addGestureRecognizer(tapGestureRecognizer)
        
        contactImageView.applyRoundedEdges()
        
        colourPicker.delegate = self
        colourPicker.dataSource = self
        
        colourTextField.inputView = colourPicker
        colourTextField.tintColor = UIColor.clear
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        print("sd")
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
    }
}

extension EditContactTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("didFinishPickingMediaWithInfo")
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        contactImageView.contentMode = .scaleAspectFill
        contactImageView.image = chosenImage
        //prepareImageForSaving(image: chosenImage)
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("imagePickerControllerDidCancel")
    }
}

extension EditContactTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
    }
}
