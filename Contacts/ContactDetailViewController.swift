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
        if let username = contact.value(forKeyPath: "username") as? String {
            detailTableView?.contactUsernameLabel.text = username
        }
        if let email = contact.value(forKeyPath: "email") as? String {
            detailTableView?.contactEmailLabel.text = email
        }
        if let phone = contact.value(forKeyPath: "phone") as? String {
            detailTableView?.contactPhoneLabel.text = phone
        }
        if let website = contact.value(forKeyPath: "website") as? String {
            detailTableView?.contactWebsiteLabel.text = website
        }
        
        if let street = contact.value(forKeyPath: "street") as? String {
            detailTableView?.streetLabel.text = street
        }
        if let suite = contact.value(forKeyPath: "suite") as? String {
            detailTableView?.suiteLabel.text = suite
        }
        if let city = contact.value(forKeyPath: "city") as? String {
            detailTableView?.cityLabel.text = city
        }
        if let zipcode = contact.value(forKeyPath: "zipcode") as? String {
            detailTableView?.zipcodeLabel.text = zipcode
        }
        
        if let companyName = contact.value(forKeyPath: "companyName") as? String {
            detailTableView?.companyLabel.text = companyName
        }
        
        if let imageData = contact.value(forKeyPath: "image") as? NSData {
            contactImageView.image = UIImage(data: imageData as Data)
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        contactImageView.isUserInteractionEnabled = true
        contactImageView.addGestureRecognizer(tapGestureRecognizer)
        
        contactImageView.layer.cornerRadius = contactImageView.frame.size.width / 2
        contactImageView.clipsToBounds = true
        contactImageView.layer.borderColor = UIColor.white.cgColor
        contactImageView.layer.borderWidth = 2.0
        
        switch detailView {
        case .new:
            print("New View")
        case .edit:
            print("Edit View")
        case .view:
            print("View View")
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
        }
        
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
        
        if let username = detailTableView?.contactUsernameLabel.text {
            contact.setValue(username, forKey: "username")
        }
        
        if let email = detailTableView?.contactEmailLabel.text {
            contact.setValue(email, forKey: "email")
        }
        
        if let phone = detailTableView?.contactPhoneLabel.text {
            contact.setValue(phone, forKey: "phone")
        }
        
        if let website = detailTableView?.contactWebsiteLabel.text {
            contact.setValue(website, forKey: "website")
        }
        
        if let street = detailTableView?.streetLabel.text {
            contact.setValue(street, forKey: "street")
        }
        
        if let suite = detailTableView?.suiteLabel.text {
            contact.setValue(suite, forKey: "suite")
        }
        
        if let city = detailTableView?.cityLabel.text {
            contact.setValue(city, forKey: "city")
        }
        
        if let zipcode = detailTableView?.zipcodeLabel.text {
            contact.setValue(zipcode, forKey: "zipcode")
        }
        
        if let companyName = detailTableView?.companyLabel.text {
            contact.setValue(companyName, forKey: "companyName")
        }
        
        do {
            try managedContext.save()
            print("save success")
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

extension CGSize {
    func resizeFill(toSize: CGSize) -> CGSize {
        let scale : CGFloat = (self.height / self.width) < (toSize.height / toSize.width) ? (self.height / toSize.height) : (self.width / toSize.width)
        return CGSize(width: (self.width / scale), height: (self.height / scale))
    }
}

extension UIImage {
    
    func scale(toSize newSize:CGSize) -> UIImage {
        
        let aspectFill = self.size.resizeFill(toSize: newSize)
        
        UIGraphicsBeginImageContextWithOptions(aspectFill, false, 0.0);
        self.draw(in: CGRect(x: 0, y: 0, width: aspectFill.width, height: aspectFill.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
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
