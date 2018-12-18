//
//  PuppyCell.swift
//  MovinViewsIn_Example
//
//  Created by Vanessa Petrosky on 11/15/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class PuppyCell: UITableViewCell {
    
    static let cellIdentifier: String = "Puppy Cell"
    
    @IBOutlet weak var puppyImageView: UIImageView!
    
    func configureCell(withPuppyImage image: UIImage) {
        puppyImageView.image = image
        puppyImageView.clipsToBounds = true
    }
}
