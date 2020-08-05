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
    
    private init() {}
    
    func alert(_ title: String, _ message: String, sender: UIViewController)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            NSLog ("OK Pressed.")}

        alertController.addAction(okAction)
        
        sender.present(alertController, animated: true, completion: nil)
    }
}
