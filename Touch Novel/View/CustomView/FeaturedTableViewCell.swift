//
//  FeaturedTableViewCell.swift
//  Touch Novel
//
//  Created by Tong Yi on 5/25/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit
import Nuke
import ViewAnimator

class FeaturedTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource
{
    @IBOutlet weak var featuredCollectionView: UICollectionView!
    
    weak var delegate: CollectionRowDelegate?
    
    let zoomAnimation = AnimationType.zoom(scale: 0.2)
    let rotateAnimation = AnimationType.rotate(angle: CGFloat.pi/6)
    
    let options = ImageLoadingOptions (
        placeholder: UIImage(named: "bookImage"),
        contentModes: .init(success: .scaleAspectFill, failure: .center, placeholder: .center)
    )
    
    var listNovel = [DataModel.Novel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Collection View DataSource & Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return listNovel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppConstants.Cell.collectionViewCellId, for: indexPath) as! BookCollectionViewCell
        let data = listNovel[indexPath.item]
        cell.bookTitle.text = "\(data.title)\n \(data.author)"
        cell.contentMode = .scaleToFill
        
        guard let url = data.imageUrl else { return cell}
        
        //MARK: third PL -> NUKE -> load image from web
        Nuke.loadImage(with: url, options: options, into: cell.bookImageView)

        if indexPath.item % 2 == 0
        {
            cell.backgroundColor = UIColor(red: 137.0/255.0, green: 190.0/255.0, blue: 178.0/255.0, alpha: 1)
        }
        else
        {
            cell.backgroundColor = UIColor(red: 201.0/255.0, green: 186.0/255.0, blue: 131.0/255.0, alpha: 1)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        UIView.animate(views: [cell], animations: [zoomAnimation, rotateAnimation], duration: 2.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
//        if !isEditing {
            collectionView.deselectItem(at: indexPath, animated: true)
            let item = listNovel[indexPath.item]
            
            if delegate != nil {
                delegate?.collectionCellTapped(item: item)
            }
//        }
    }
    
    func editingState(_ edit: Bool) {
        setEditing(edit, animated: edit)
        featuredCollectionView.allowsMultipleSelection = edit
    }
    
    //MARK: - Initializer for collection view
    private func initCollectionView()
    {
        self.featuredCollectionView.delegate = self
        self.featuredCollectionView.dataSource = self
    }
    
    //MARK: - Method for getting data from the outside
    func setData(listNovel: [DataModel.Novel])
    {
        self.initCollectionView()
        self.listNovel = listNovel
        self.featuredCollectionView.reloadData()
    }

}

//MARK: - UICollectionView Delegate FlowLayout
extension FeaturedTableViewCell: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
