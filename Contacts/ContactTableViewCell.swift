//
//  ContactTableViewCell.swift
//  Contacts
//
//  Created by Simon Archer on 2017/07/25.
//  Copyright © 2017 Simon Archer. All rights reserved.
//

import UIKit
import MessageUI

protocol ContactTableViewCellDelegate {
    func sendEmail(email: String)
}

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var emailButton: UIButton!
    
    var delegate: ContactTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func emailButtonPressed(_ sender: UIButton) {
        if let email = emailLabel.text {
            delegate?.sendEmail(email: email)
        }
    }
}
