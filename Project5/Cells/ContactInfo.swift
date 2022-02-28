//
//  ContactInfo.swift
//  Project5
//
//  Created by shio birbichadze on 1/14/22.
//  Copyright © 2022 shio birbichadze. All rights reserved.
//

import UIKit

class ContactInfo: UICollectionViewCell {

    @IBOutlet var content:UIView!
    
    @IBOutlet var circle:UIView!
    @IBOutlet var title:UILabel!
    @IBOutlet var name:UILabel!
    @IBOutlet var number:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        circle.layer.cornerRadius=circle.bounds.width/2
//        circle.layer.masksToBounds=true
//
//        content.layer.cornerRadius=content.bounds.width/12
//        content.layer.masksToBounds=true
//
//    }
    
    

}


class Circle:UIView{
    
    override func layoutSubviews() {
        layer.cornerRadius=frame.width/2
    }
    
}

class Content:UIView{
    
    override func layoutSubviews() {
        layer.cornerRadius=15
    }
    
}
