//
//  CustomTableViewCell.swift
//  PlaceFinder
//
//  Created by Sergey on 24.04.2022.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var imageOfPlace: UIImageView! {
        didSet {
            imageOfPlace?.layer.cornerRadius = imageOfPlace.frame.size.height/2
            imageOfPlace?.clipsToBounds = true
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var currentStars: Rating! {
        didSet {
            currentStars.isUserInteractionEnabled = false
        }
    }
    
}
