//
//  AlertManager.swift
//  Touch Novel
//
//  Created by Tong Yi on 8/4/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

class AlertManager
{
    static let shared = AlertManager()
    typealias handler = () -> ()
    
    private init() {}
    
    func alert(_ title: String, _ message: String?, sender: UIViewController)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            NSLog ("OK Pressed.")}

        alertController.addAction(okAction)
        
        sender.present(alertController, animated: true, completion: nil)
    }
    
    func action(bookTitle: String, entityName: String? = nil, sender: UIViewController, handler: @escaping handler)
    {
        let alertController = UIAlertController(title: "Would you like to remove the book from reading list?", message: nil, preferredStyle: .actionSheet)
        
        let removeAction = UIAlertAction(title: "Remove", style: .destructive) { (action) -> Void in
            let viewModel = ViewModel()
            viewModel.deleteBook(title: bookTitle, entityName: entityName)
            
            self.alert("Book has been removed.", nil, sender: sender)
            handler()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(removeAction)
        alertController.addAction(cancelAction)
        
        sender.present(alertController, animated: true, completion: nil)
    }
}
