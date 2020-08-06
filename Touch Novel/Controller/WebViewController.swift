//
//  WebViewController.swift
//  Touch Novel
//
//  Created by Tong Yi on 5/27/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit
import WebKit
import MBProgressHUD

class WebViewController: UIViewController, WKNavigationDelegate
{
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var goForwardButton: UIBarButtonItem!
    @IBOutlet weak var goBackwardButton: UIBarButtonItem!
    
    var book: DataModel.Novel!
    var isInReadingList = false
    var isFavorite = false
    lazy var viewModel = ViewModel()
    
    
    lazy var addToListButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "book"), style: .plain, target: self, action: #selector(didAddToListButtonTapped))
        return barButtonItem
    }()
    
    lazy var alreadyInListButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "book.fill"), style: .plain, target: self, action: #selector(didAlreadyInListButtonTapped))
        return barButtonItem
    }()
    
    lazy var notFavoriteButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(didNotFavoriteButtonTapped))
        return barButtonItem
    }()
    
    lazy var favouriteButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(didFavoriteButtonTapped))
        return barButtonItem
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI()
    {
        let request = URLRequest(url: book.webReaderUrl!)
        
        navigationItem.rightBarButtonItems = [goForwardButton, goBackwardButton, isFavoriteBookButton(isFavorite), isBookInTheListButton(isInReadingList)]
        
        webView.navigationDelegate = self
        webView.load(request)
    }
    
    @IBAction func goBackButtonTapped(_ sender: UIBarButtonItem)
    {
        if webView.canGoBack
        {
            webView.goBack()
        }
    }
    
    @IBAction func goForwardButtonTapped(_ sender: UIBarButtonItem)
    {
        if webView.canGoForward
        {
            webView.goForward()
        }
    }
    
    //MARK: - selector methods
    
    @objc func didAddToListButtonTapped(_ sender: UIBarButtonItem)
    {
        isInReadingList = !isInReadingList
        
        navigationItem.rightBarButtonItems = [goForwardButton, goBackwardButton, isFavoriteBookButton(isFavorite), isBookInTheListButton(isInReadingList)]
          
        viewModel.addBook(title: book.title, author: book.author, image: book.imageUrl, webReader: book.webReaderUrl, sender: self)
    }
    
    @objc func didAlreadyInListButtonTapped(_ sender: UIBarButtonItem)
    {
        let title = book.title
        
        AlertManager.shared.action(bookTitle: title, sender: self) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.isInReadingList = !weakSelf.isInReadingList
            weakSelf.navigationItem.rightBarButtonItems = [weakSelf.goForwardButton, weakSelf.goBackwardButton, weakSelf.isFavoriteBookButton(weakSelf.isFavorite), weakSelf.isBookInTheListButton(weakSelf.isInReadingList)]
        }
    }
    
    @objc func didNotFavoriteButtonTapped(_ sender: UIBarButtonItem)
    {
        isFavorite = !isFavorite
        
        navigationItem.rightBarButtonItems = [goForwardButton, goBackwardButton, isFavoriteBookButton(isFavorite), isBookInTheListButton(isInReadingList)]
          
        viewModel.addBook(title: book.title, author: book.author, image: book.imageUrl, webReader: book.webReaderUrl, entityName: AppConstants.EntityName.favoriteBook, sender: self)
    }
    
    @objc func didFavoriteButtonTapped(_ sender: UIBarButtonItem)
    {
        let title = book.title
        
        AlertManager.shared.action(bookTitle: title, entityName: AppConstants.EntityName.favoriteBook, sender: self) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.isFavorite = !weakSelf.isFavorite
            weakSelf.navigationItem.rightBarButtonItems = [weakSelf.goForwardButton, weakSelf.goBackwardButton, weakSelf.isFavoriteBookButton(weakSelf.isFavorite), weakSelf.isBookInTheListButton(weakSelf.isInReadingList)]
        }
    }
    
    //MARK: - Help Methods
    
    func isFavoriteBookButton(_ check: Bool) -> UIBarButtonItem {
        if check {
            return favouriteButton
        } else {
            return notFavoriteButton
        }
    }
    
    func isBookInTheListButton(_ check: Bool) -> UIBarButtonItem {
        if check {
            return alreadyInListButton
        } else {
            return addToListButton
        }
    }
    
    //MARK: - 3PL -> MBProgressHUD -> use as activity indicator
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        let activityIndicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        activityIndicator.label.text = "Loading"
        activityIndicator.detailsLabel.text = "Please wait"
//        activityIndicator.isUserInteractionEnabled = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
}
