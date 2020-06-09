//
//  FavoriteCollectionViewCell.swift
//  Touch Novel
//
//  Created by Tong Yi on 5/26/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

class FavoriteCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var checkMarkImage: UIImageView!
    @IBOutlet weak var highLightIndicator: UIView!
    
    override var isHighlighted: Bool {
        didSet{
            highLightIndicator.isHidden = !isHighlighted
        }
    }
    
    override var isSelected: Bool {
        didSet {
            highLightIndicator.isHidden = !isSelected
            checkMarkImage.isHidden = !isSelected
        }
    }
}
