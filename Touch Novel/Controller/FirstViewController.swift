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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.refreshData()
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
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = true
        
        navigationItem.rightBarButtonItem = selectBarButton
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationController!.navigationBar.barStyle = .black
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(red: 222/255, green: 156/255, blue: 83/255, alpha: 1)
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.8)]

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
        var count = 0
        for (key, value) in selectedIndexPath
        {
            if value
            {
                deleteIndexPaths.append(key)
            }
        }
        
        guard deleteIndexPaths.count != 0 else { return }
        count = deleteIndexPaths.count
        
        for indexPath in deleteIndexPaths
        {
            let book = viewModel.bookObject(at: indexPath)
            
            if count == 1
            {
                deleteFinishFlag = true
            }
            
            guard let title = book.title else { return }
            viewModel.deleteBook(title: title, completeState: deleteFinishFlag)
            count -= 1
        }
        
        selectedIndexPath.removeAll()
        viewModel.refreshData()
    }
    
    //MARK: - prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let item = sender as! Book
        if segue.identifier == AppConstants.SB.webViewSegueId
        {
            guard let vc = segue.destination as? WebViewController, let title = item.title, let author = item.author else {return}
            
            vc.book = DataModel.Novel(title: title, author: author, imageUrl: item.imageURL, webReaderUrl: item.webReaderURL)
            vc.isInReadingList = true
            
            viewModel.fetchBooksThroughBookTitle(title: title, entityName: AppConstants.EntityName.favoriteBook) { _ in
                vc.isFavorite = true
            }
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
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int)
    {
        if let searchText = searchBar.searchTextField.text, !searchText.isEmpty
        {
            viewModel.fetchObj(selectedScopeIndx: searchBar.selectedScopeButtonIndex, searchText: searchText)

            collectionView.reloadData()
        }
        else
        {
            viewModel.fetchObj()
            collectionView.reloadData()
        }
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool
    {
        searchBar.scopeButtonTitles = ["title", "author"]
        searchBar.selectedScopeButtonIndex = 0
        isSearchActive = true
        collectionView.reloadData()
        return true
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool
    {
        isSearchActive = false
        collectionView.reloadData()
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.scopeButtonTitles = nil
        viewModel.fetchObj()
        collectionView.reloadData()
    }
}



