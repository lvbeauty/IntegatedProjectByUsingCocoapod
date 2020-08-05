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
    var url: URL?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI()
    {
        let request = URLRequest(url: url!)
        
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
    
    @IBAction func favoriteButtonTapped(_ sender: Any)
    {
        
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
