//
//  FirstViewController.swift
//  Touch Novel
//
//  Created by Tong Yi on 5/24/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit
import Nuke
import ViewAnimator

class FirstViewController: UIViewController
{
    @IBOutlet weak var collectionView: UICollectionView!
    
    var readingList = [DataModel.Novel]()
    let service = Service.shared
    var selectedIndexPath: [IndexPath: Bool] = [:]
    let fromAnimation = AnimationType.from(direction: .right, offset: 30.0)
    let zoomAnimation = AnimationType.zoom(scale: 0.2)
    let rotateAnimation = AnimationType.rotate(angle: CGFloat.pi/6)
    private var noResultLabel: UILabel!
    
    let options = ImageLoadingOptions(
        placeholder: UIImage(named: "bookImage"),
        contentModes: .init(success: .scaleAspectFill, failure: .center, placeholder: .center)
    )
    
    var myModel: DataModel.Model = .view {
        didSet{
            switch myModel {
            case .view:
                for (key, value) in selectedIndexPath
                {
                    if value
                    {
                        collectionView.deselectItem(at: key, animated: true)
                    }
                }
                selectedIndexPath.removeAll()
                selectBarButton.title = "Select"
                navigationItem.leftBarButtonItem = nil
                collectionView.allowsMultipleSelection = false
            case .select:
                selectBarButton.title = "Cancel"
                navigationItem.leftBarButtonItem = deleteBarButton
                collectionView.allowsMultipleSelection = true
            }
        }
    }

    //MARK: - View life cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    //MARK: Set Up for UIElements
    
    private func setupUI()
    {
//        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = selectBarButton
        
        noResultLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.collectionView.bounds.width, height: self.collectionView.bounds.height))
        noResultLabel.numberOfLines = 0
        noResultLabel.text = ""
    
        setupCollectionViewLayout()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    //MARK: - Set UP Data
    private func setupData()
    {
        let sec = AppConstants.Network.urls.count - 1
        service.fetchData(section: sec) { (datas) in
            
            guard let data = datas else {return}
            
            self.readingList = data
            self.collectionView.reloadData()
        }
    }
    
    private func setupCollectionViewLayout()
    {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 116, height: 200)
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .black
    }
    
    //MARK: - Bar Button Items
    lazy var selectBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(didSelectButtonTapped))
        return barButtonItem
    }()
    
    lazy var deleteBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didDeleteButtonTapped))
        return barButtonItem
    }()
    
    @objc func didSelectButtonTapped(_ sender: UIBarButtonItem)
    {
        myModel = myModel == .view ? .select : .view
    }
    
    @objc func didDeleteButtonTapped(_ sender: UIBarButtonItem)
    {
        var deleteIndexPaths: [IndexPath] = []
        for (key, value) in selectedIndexPath
        {
            if value
            {
                deleteIndexPaths.append(key)
            }
        }
        
        for cell in deleteIndexPaths.sorted(by: {$0.item > $1.item})
        {
            readingList.remove(at: cell.item)
        }
        
        collectionView.deleteItems(at: deleteIndexPaths)
        selectedIndexPath.removeAll()
    }
    
    //MARK: - prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let item = sender as! DataModel.Novel
        if segue.identifier == AppConstants.SB.webViewSegueId
        {
            guard let vc = segue.destination as? WebViewController else {return}
            vc.url = item.webReaderUrl
        }
    }
    
    //MARK: - No result showing Label
    func showNoResultLabel(_ text: String) -> UIView
    {
        noResultLabel.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 60)
        noResultLabel.text = text
        noResultLabel.textAlignment = NSTextAlignment.center
        noResultLabel.textColor = .white
        
        return noResultLabel
    }
}

//MARK: - Collection View
extension FirstViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if readingList.count == 0 {
            collectionView.backgroundView = showNoResultLabel(AppConstants.noDataToShow)
        } else {
            collectionView.backgroundView = UIView()
        }
        
        return readingList.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppConstants.Cell.favoritCollectionCellId, for: indexPath) as! FavoriteCollectionViewCell
        let data = readingList[indexPath.row]
        cell.bookTitle.text = "\(data.title)\n \(data.author)"
        cell.bookImageView.image = #imageLiteral(resourceName: "bookImage")
        cell.contentMode = .scaleToFill
        guard let url = data.imageUrl else { return cell}
        //MARK: nuke
        Nuke.loadImage(with: url, options: options,into: cell.bookImageView)

        if indexPath.row % 2 == 0
        {
            cell.backgroundColor = UIColor(red: 200.0/255.0, green: 220.0/255.0, blue: 196.0/255.0, alpha: 1)
        }
        else
        {
            cell.backgroundColor = UIColor(red: 255.0/255.0, green: 200.0/255.0, blue: 196.0/255.0, alpha: 1)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        //MARK: 3PL -> ViewAnimator -> animated
        UIView.animate(views: [cell], animations: [zoomAnimation, rotateAnimation], duration: 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        switch myModel {
        case .view:
            collectionView.deselectItem(at: indexPath, animated: true)
            let item = readingList[indexPath.item]
            performSegue(withIdentifier: AppConstants.SB.webViewSegueId, sender: item)
        case .select:
            selectedIndexPath[indexPath] = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
    {
        if myModel == .select
        {
            selectedIndexPath[indexPath] = false
        }
    }
}



