//
//  FavoriteTableViewCell.swift
//  Touch Novel
//
//  Created by Tong Yi on 8/6/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit
import Nuke

class FavoriteTableViewCell: UITableViewCell {
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    lazy var viewModel = ViewModel(entityName: "FavoriteBook")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    let options = ImageLoadingOptions(
        placeholder: UIImage(named: "bookImage"),
        contentModes: .init(success: .scaleAspectFill, failure: .center, placeholder: .center)
    )
    
    func configureCell(indexPath: IndexPath)
    {
        let book = viewModel.favoriteBookObject(at: indexPath)
        
        self.titleLabel.text = book.title
        self.authorLabel.text = book.author
        self.bookImage.image = #imageLiteral(resourceName: "bookImage")
        
        guard let url = book.imageURL else { return }
        //MARK: nuke
        Nuke.loadImage(with: url, options: options, into: self.bookImage)
    }

}
