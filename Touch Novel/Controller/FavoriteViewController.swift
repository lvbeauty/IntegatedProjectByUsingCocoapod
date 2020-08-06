//
//  FavoriteViewController.swift
//  Touch Novel
//
//  Created by Tong Yi on 8/6/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    lazy var viewModel = ViewModel(entityName: "FavoriteBook")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        setupViewModel()
    }
    
    private func setupUI()
    {
        tableView.tableFooterView = UIView()
    }
    
    private func setupViewModel()
    {
        viewModel.updateHandler = self.tableView.reloadData
    }
    
    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return viewModel.numberOfItems(at: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell", for: indexPath) as! FavoriteTableViewCell
        
        cell.configureCell(indexPath: indexPath)
        
        return cell
    }
    
    // MARK: - Table view data Delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = viewModel.favoriteBookObject(at: indexPath)
        performSegue(withIdentifier: AppConstants.SB.webViewSegueId3, sender: item)
        
    }

    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let item = sender as! FavoriteBook
        if segue.identifier == AppConstants.SB.webViewSegueId3
        {
            guard let vc = segue.destination as? WebViewController, let title = item.title, let author = item.author else {return}
            
            vc.book = DataModel.Novel(title: title, author: author, imageUrl: item.imageURL, webReaderUrl: item.webReaderURL)
            vc.isFavorite = true
            
            viewModel.fetchBooksThroughBookTitle(title: title, entityName: AppConstants.EntityName.book) { _ in
                vc.isInReadingList = true
            }
        }
    }
}


