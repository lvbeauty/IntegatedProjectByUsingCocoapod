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
    
//    var readingList = [DataModel.Novel]()
    let service = Service.shared
    var selectedIndexPath: [IndexPath: Bool] = [:]
    let fromAnimation = AnimationType.from(direction: .right, offset: 30.0)
    let zoomAnimation = AnimationType.zoom(scale: 0.2)
    let rotateAnimation = AnimationType.rotate(angle: CGFloat.pi/6)
    private var noResultLabel: UILabel!
    private let searchController = UISearchController(searchResultsController: nil)
    lazy var viewModel = ViewModel()
    private var isSearchActive = false
    
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
        setupViewModel()
//        setupData()
    }
    
    //MARK: Set Up for UIElements
    
    private func setupViewModel()
    {
        viewModel.updateHandler = self.collectionView.reloadData
    }
    
    private func setupUI()
    {
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Search Book"
        searchController.searchBar.scopeButtonTitles = ["title", "author"]
        searchController.searchBar.selectedScopeButtonIndex = 0
        searchController.searchBar.showsScopeBar = false
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = true
        
        navigationItem.rightBarButtonItem = selectBarButton
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationController!.navigationBar.barStyle = .black
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(red: 255/255, green: 77/255, blue: 119/255, alpha: 1)
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]

        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance

        let searchField = searchController.searchBar.searchTextField
        searchField.backgroundColor = .systemBackground
        
        noResultLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.collectionView.bounds.width, height: self.collectionView.bounds.height))
        noResultLabel.numberOfLines = 0
        noResultLabel.text = ""
    
        setupCollectionViewLayout()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    //MARK: - Set UP Data
//    private func setupData()
//    {
//        let sec = AppConstants.Network.urls.count - 1
//        service.fetchData(section: sec) { (datas) in
//
//            guard let data = datas else {return}
//
//            self.readingList = data
//
//            for item in self.readingList {
//                self.viewModel.addBook(title: item.title, author: item.author, image: item.imageUrl, webReader: item.webReaderUrl, sender: nil)
//            }
//
//            self.collectionView.reloadData()
//        }
//    }
    
    private func setupCollectionViewLayout()
    {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (view.frame.width - 5 * 2 - 8 * 2) / 3.0, height: 200)
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
        var deleteFinishFlag = false
        for (key, value) in selectedIndexPath
        {
            if value
            {
                deleteIndexPaths.append(key)
            }
        }
        
        for indexPath in deleteIndexPaths
        {
            let book = viewModel.bookObject(at: indexPath)
            
            if indexPath.item == deleteIndexPaths.count - 1
            {
                deleteFinishFlag = true
            }
            
            guard let title = book.title else { return }
            viewModel.deleteBook(title: title, completeState: deleteFinishFlag)
        }
        
        viewModel.refreshData()
    }
    
    //MARK: - prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let item = sender as! Book
        if segue.identifier == AppConstants.SB.webViewSegueId
        {
            guard let vc = segue.destination as? WebViewController else {return}
            vc.url = item.webReaderURL
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
        let numOfItems = viewModel.numberOfItems(at: section)
        
        if numOfItems == 0 {
            collectionView.backgroundView = showNoResultLabel(AppConstants.noDataToShow)
        } else {
            collectionView.backgroundView = UIView()
        }
        
        return numOfItems
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppConstants.Cell.favoritCollectionCellId, for: indexPath) as! FavoriteCollectionViewCell
        
        cell.configureCell(indexPath: indexPath)
//        let data = readingList[indexPath.row]
//        cell.bookTitle.text = "\(data.title)\n \(data.author)"
//        cell.bookImageView.image = #imageLiteral(resourceName: "bookImage")
//        cell.contentMode = .scaleToFill
//        guard let url = data.imageUrl else { return cell}
//        //MARK: nuke
//        Nuke.loadImage(with: url, options: options,into: cell.bookImageView)
//
//        if indexPath.row % 2 == 0
//        {
//            cell.backgroundColor = UIColor(red: 200.0/255.0, green: 220.0/255.0, blue: 196.0/255.0, alpha: 1)
//        }
//        else
//        {
//            cell.backgroundColor = UIColor(red: 255.0/255.0, green: 200.0/255.0, blue: 196.0/255.0, alpha: 1)
//        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        //MARK: 3PL -> ViewAnimator -> animated
        if !isSearchActive{
            UIView.animate(views: [cell], animations: [zoomAnimation, rotateAnimation], duration: 1.5)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        switch myModel {
        case .view:
            collectionView.deselectItem(at: indexPath, animated: true)
            let item = viewModel.bookObject(at: indexPath)
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

//MARK: - Search Result updating and Delegate

extension FirstViewController: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if !searchText.isEmpty
        {
            viewModel.fetchObj(selectedScopeIndx: searchBar.selectedScopeButtonIndex, searchText: searchText)
            collectionView.reloadData()
        }
        else
        {
            viewModel.fetchObj(sortKey: searchBar.scopeButtonTitles?[searchBar.selectedScopeButtonIndex])
            collectionView.reloadData()
        }
    }
    
//    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int)
//    {
//        if let searchText = searchBar.searchTextField.text, !searchText.isEmpty
//        {
//            viewModel.fetchObj(selectedScopeIndx: searchBar.selectedScopeButtonIndex, searchText: searchText)
//
//            collectionView.reloadData()
//        }
//        else
//        {
//            viewModel.fetchObj()
//            collectionView.reloadData()
//        }
//    }
//
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool
    {
        searchBar.showsScopeBar = true
        isSearchActive = true
        collectionView.reloadData()
        return true
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool
    {
        searchBar.showsScopeBar = false
        isSearchActive = false
        collectionView.reloadData()
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        viewModel.fetchObj()
        collectionView.reloadData()
    }
}



