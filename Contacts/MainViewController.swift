//
//  MainViewController.swift
//  Contacts
//
//  Created by Simon Archer on 2017/07/26.
//  Copyright © 2017 Simon Archer. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController {

    @IBOutlet weak var footerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.setNeedsStatusBarAppearanceUpdate()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(footerLabelTapped(tapGestureRecognizer:)))
        footerLabel.isUserInteractionEnabled = true
        footerLabel.addGestureRecognizer(tapGestureRecognizer)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func footerLabelTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: "Delete CoreData", message:
            "Are you sure you want to delete all Contact data?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            self.deleteAllRecords()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
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
