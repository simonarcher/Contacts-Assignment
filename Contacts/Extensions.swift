//
//  Extensions.swift
//  Contacts
//
//  Created by Simon Archer on 2017/07/26.
//  Copyright © 2017 Simon Archer. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func setColour() {
        
        if let text = self.text {
            switch text {
            case "Red":
                self.textColor = UIColor.red
            case "Green":
                self.textColor = UIColor.green
            case "Blue":
                self.textColor = UIColor.blue
            case "Purple":
                self.textColor = UIColor.purple
            case "Orange":
                self.textColor = UIColor.orange
            case "Yellow":
                self.textColor = UIColor.yellow
            default:
                self.textColor = UIColor.black
            }
        }
    }
}

extension UIImageView {
    func applyRoundedEdges() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2.0
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
