//
//  ContactDetailViewController.swift
//  Contacts
//
//  Created by Simon Archer on 2017/07/25.
//  Copyright © 2017 Simon Archer. All rights reserved.
//

import UIKit
import CoreData

class ContactDetailViewController: UIViewController {

    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var detailContainerView: UIView!
    
    var detailTableView: ContactDetailTableViewController?
    
    var contact: NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let name = contact.value(forKeyPath: "name") as? String {
            detailTableView?.contactNameLabel.text = name
        }

        if let email = contact.value(forKeyPath: "email") as? String {
            detailTableView?.contactEmailLabel.text = email
        }
        
        if let phone = contact.value(forKeyPath: "phone") as? String {
            detailTableView?.contactPhoneLabel.text = phone
        }
        
        if let colour = contact.value(forKeyPath: "colour") as? String {
            detailTableView?.colourTextField.text = colour
            detailTableView?.colourTextField.setColour()
        }
        
        if let imageData = contact.value(forKeyPath: "image") as? NSData {
            contactImageView.image = UIImage(data: imageData as Data)
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        contactImageView.isUserInteractionEnabled = true
        contactImageView.addGestureRecognizer(tapGestureRecognizer)
        
        contactImageView.applyRoundedEdges()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
        
        detailTableView?.delegate = self
    }
    
    func saveTapped() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if let name = detailTableView?.contactNameLabel.text {
            contact.setValue(name, forKey: "name")
        }
        
        if let email = detailTableView?.contactEmailLabel.text {
            contact.setValue(email, forKey: "email")
        }
        
        if let phone = detailTableView?.contactPhoneLabel.text {
            contact.setValue(phone, forKey: "phone")
        }
        
        if let colour = detailTableView?.colourTextField.text {
            contact.setValue(colour, forKey: "colour")
        }
        
        do {
            try managedContext.save()
            print("save success")
            self.navigationController?.popViewController(animated: true)
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
        managedContext.refreshAllObjects()
        
        self.detailTableView?.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailTableViewSegue" {
            print("DetailTableViewSegue")
            
            detailTableView = segue.destination as? ContactDetailTableViewController
        }
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

extension ContactDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("didFinishPickingMediaWithInfo")
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        contactImageView.contentMode = .scaleAspectFill
        contactImageView.image = chosenImage
        prepareImageForSaving(image: chosenImage)
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("imagePickerControllerDidCancel")
    }
    
    func prepareImageForSaving(image:UIImage) {
        
        let thumbnail = image.scale(toSize: self.view.frame.size)
        
        guard let thumbnailData  = UIImageJPEGRepresentation(thumbnail, 0.7) else {
            // handle failed conversion
            print("jpg error")
            return
        }
    
        self.saveImage(thumbnailData: thumbnailData as NSData)
    }
    
    func saveImage(thumbnailData:NSData) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        contact.setValue(thumbnailData, forKeyPath: "image")
    
        do {
            try managedContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    
        managedContext.refreshAllObjects()
    }
}

extension ContactDetailViewController: ContactDetailTableViewControllerDelegate {
    func deleteContact() {
        print("delete contact")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        managedContext.delete(contact)
        
        do {
            try managedContext.save()
            managedContext.refreshAllObjects()
            self.navigationController?.popViewController(animated: true)
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
}
