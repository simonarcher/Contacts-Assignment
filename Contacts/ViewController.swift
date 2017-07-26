//
//  ViewController.swift
//  Contacts
//
//  Created by Simon Archer on 2017/07/25.
//  Copyright © 2017 Simon Archer. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class ViewController: UIViewController {

    @IBOutlet weak var contactsTableView: UITableView!
    
    var contacts: [NSManagedObject] = []
    var selectedContact: NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        
        contactsTableView.tableFooterView = UIView()
        
        let voucherCellXib = UINib(nibName: "ContactTableViewCell", bundle: nil)
        contactsTableView.register(voucherCellXib, forCellReuseIdentifier: "ContactCell")
        
        //deleteAllRecords()
    }
    
    func getJsonData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Contact", in: managedContext)!

        let dataURL = URL(string: "https://jsonplaceholder.typicode.com/users")
        let task = URLSession.shared.dataTask(with: dataURL!) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                if let content = data {
                    do {
                        let jsonData = try JSONSerialization.jsonObject(with: content, options: .mutableContainers) as AnyObject
                        if let jsonArray = jsonData as? Array<AnyObject> {
                            
                            for element in jsonArray {
                                
                                let contact = NSManagedObject(entity: entity, insertInto: managedContext)
                                
                                if let name = element.value(forKey: "name") {
                                    print("Save name - \(name)")
                                    contact.setValue(name, forKeyPath: "name")
                                }
                                
                                if let username = element.value(forKey: "username") {
                                    contact.setValue(username, forKeyPath: "username")
                                }
                                
                                if let phone = element.value(forKey: "phone") {
                                    contact.setValue(phone, forKeyPath: "phone")
                                }
                                
                                if let email = element.value(forKey: "email") {
                                    contact.setValue(email, forKeyPath: "email")
                                }
                                
                                if let website = element.value(forKey: "website") {
                                    contact.setValue(website, forKeyPath: "website")
                                }
                                
                                if let company = element.value(forKey: "company") {
                                    if let companyName = (company as AnyObject).value(forKey: "name") {
                                        contact.setValue(companyName, forKeyPath: "companyName")
                                    }
                                }
                                
                                if let address = element.value(forKey: "address") {
                                    if let street = (address as AnyObject).value(forKey: "street") {
                                        contact.setValue(street, forKeyPath: "street")
                                    }
                                    
                                    if let suite = (address as AnyObject).value(forKey: "suite") {
                                        contact.setValue(suite, forKeyPath: "suite")
                                    }
                                    
                                    if let city = (address as AnyObject).value(forKey: "city") {
                                        contact.setValue(city, forKeyPath: "city")
                                    }
                                    
                                    if let zipcode = (address as AnyObject).value(forKey: "zipcode") {
                                        contact.setValue(zipcode, forKeyPath: "zipcode")
                                    }
                                }
                                
                                do {
                                    try managedContext.save()
                                    self.contacts.append(contact)
                                } catch let error as NSError {
                                    print("Could not save. \(error), \(error.userInfo)")
                                }
                            }
                            
                            self.contacts.sort(by: { (contact1, contact2) -> Bool in
                                contact2.value(forKey: "name") as! String > contact1.value(forKey: "name") as! String
                            })
                            
                            DispatchQueue.main.async() {
                                self.contactsTableView.reloadData()
                            }
                            
                        }
                    }
                    catch {
                        print("Failed to convert JSON")
                    }
                }
            }
        }
        
        task.resume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Contact")
        
        do {
            contacts = try managedContext.fetch(fetchRequest)
            if contacts.count == 0 {
                print("Contacts are empty. Getting JSON Data")
                getJsonData()
            } else {
                self.contacts.sort(by: { (contact1, contact2) -> Bool in
                    contact2.value(forKey: "name") as! String > contact1.value(forKey: "name") as! String
                })
                contactsTableView.reloadData()
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier! {
        case "EditContactSegue":
            print("Preparing segue for EditContactSegue")
        case "ContactDetailSegue":
            print("Preparing segue for EditContactSegue")
            let destVC = segue.destination as! ContactDetailViewController
            destVC.contact = selectedContact
        default:
            print("Preparing segue for default")
        }
    }

    @IBAction func addContactButtonPressed(_ sender: UIBarButtonItem) {
        print("addContactButtonPressed")
        
        performSegue(withIdentifier: "EditContactSegue", sender: nil)
    }

    func deleteAllRecords() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            print("Deleted Contact Records")
        } catch {
            print ("There was an error")
        }
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row at \(indexPath.row)")
        selectedContact = contacts[indexPath.row]
        contactsTableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "ContactDetailSegue", sender: nil)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contactsTableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactTableViewCell
        let contact = contacts[indexPath.row]
        cell.nameLabel.text = contact.value(forKeyPath: "name") as? String
        
        if let email = contact.value(forKey: "email") as? String {
            cell.emailLabel.text = email
        } else {
            cell.emailLabel.text = ""
        }
        
        if let imageData = contact.value(forKeyPath: "image") as? NSData {
            cell.userImageView?.image = UIImage(data: imageData as Data)
        } else {
            cell.userImageView.image = #imageLiteral(resourceName: "UserImagePlaceholder")
        }
        
        cell.userImageView.layer.cornerRadius = cell.userImageView.frame.size.width / 2
        cell.userImageView.clipsToBounds = true
        cell.userImageView.layer.borderColor = UIColor.white.cgColor
        cell.userImageView.layer.borderWidth = 2.0
        
        cell.delegate = self
        
        return cell
    }
}

extension ViewController: ContactTableViewCellDelegate {
    func sendEmail(email: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            mail.setSubject("Email from Contacts App")
            mail.setMessageBody("<p>This is an email from the Contacts app!</p>", isHTML: true)
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
}

extension ViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
