//
//  BookCollectionViewCell.swift
//  Touch Novel
//
//  Created by Tong Yi on 5/25/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var highLightIndicator: UIView!
    @IBOutlet weak var checkMark: UIImageView!
    
    override var isHighlighted: Bool {
        didSet{
            highLightIndicator.isHidden = !isHighlighted
        }
    }
    
    override var isSelected: Bool {
        didSet {
            highLightIndicator.isHidden = !isSelected
            checkMark.isHidden = !isSelected
        }
    }
}
