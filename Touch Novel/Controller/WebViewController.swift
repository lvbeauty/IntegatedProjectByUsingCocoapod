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
    lazy var viewModel = ViewModel()
    
    
    lazy var addToListButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "addToList"), style: .plain, target: self, action: #selector(didAddToListButtonTapped))
        return barButtonItem
    }()
    
    lazy var areadlyInListButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "alreadyInList"), style: .plain, target: self, action: #selector(didAreadlyInListButtonTapped))
        return barButtonItem
    }()
    
    lazy var notFavoriteButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(didAddToListButtonTapped))
        return barButtonItem
    }()
    
    lazy var favouriteButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(didAreadlyInListButtonTapped))
        return barButtonItem
    }()
    
    @objc func didAddToListButtonTapped(_ sender: UIBarButtonItem)
    {
        navigationItem.rightBarButtonItems = [goForwardButton, goBackwardButton, areadlyInListButton]
          
        viewModel.addBook(title: book.title, author: book.author, image: book.imageUrl, webReader: book.webReaderUrl, sender: self)
    }
    
    @objc func didAreadlyInListButtonTapped(_ sender: UIBarButtonItem)
    {
        navigationItem.rightBarButtonItems = [goForwardButton, goBackwardButton, addToListButton]
        
        let title = book.title
        
        viewModel.deleteBook(title: title)
        AlertManager.shared.action(bookTitle: title, sender: self)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI()
    {
        let request = URLRequest(url: book.webReaderUrl!)
        
        if isInReadingList {
            navigationItem.rightBarButtonItems = [goForwardButton, goBackwardButton, areadlyInListButton]
        } else {
            navigationItem.rightBarButtonItems = [goForwardButton, goBackwardButton, addToListButton]
        }
        
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
