//
//  FavoriteCollectionViewCell.swift
//  Touch Novel
//
//  Created by Tong Yi on 5/26/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit
import Nuke

class FavoriteCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var checkMarkImage: UIImageView!
    @IBOutlet weak var highLightIndicator: UIView!
    
    lazy var viewModel = ViewModel()
    
    let options = ImageLoadingOptions(
        placeholder: UIImage(named: "bookImage"),
        contentModes: .init(success: .scaleAspectFill, failure: .center, placeholder: .center)
    )
    
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
    
    func configureCell(indexPath: IndexPath)
    {
        let book = viewModel.bookObject(at: indexPath)
        
        self.bookTitle.text = book.title
        self.bookImageView.image = #imageLiteral(resourceName: "bookImage")
        
        guard let url = book.imageURL else { return }
        //MARK: nuke
        Nuke.loadImage(with: url, options: options, into: self.bookImageView)
        
        if indexPath.item % 2 == 0
        {
            self.backgroundColor = UIColor(red: 200.0/255.0, green: 220.0/255.0, blue: 196.0/255.0, alpha: 1)
        }
        else
        {
            self.backgroundColor = UIColor(red: 255.0/255.0, green: 200.0/255.0, blue: 196.0/255.0, alpha: 1)
        }
        
//        self.backgroundColor = UIColor(red: 250/255, green: 200/255, blue: 210/255, alpha: 1)
    }
}
