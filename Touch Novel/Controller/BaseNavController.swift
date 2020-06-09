//
//  BaseNavController.swift
//  Touch Novel
//
//  Created by Tong Yi on 5/25/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

class BaseNavController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
    
    //MARK: - Alert method
       
    func alert(_ messageToShow: String)
    {
       let alertController = UIAlertController(title: "WARNING!", message: messageToShow, preferredStyle: .alert)
       let okAction = UIAlertAction(title: "OK", style: .default)
       {
           (action) -> Void in
           NSLog ("OK Pressed.")
       }
       alertController.addAction(okAction)
       self.present(alertController, animated: true, completion: nil)
    }

    func cheer(_ messageToShow: String)
    {
       let alertController = UIAlertController(title: "CONGRATULATE!", message: messageToShow, preferredStyle: .actionSheet)
       let okAction = UIAlertAction(title: "OK", style: .default)
       {
           (action) -> Void in
           DispatchQueue.main.async {
               UserDefaults.standard.set(false, forKey: AppConstants.UD.logInKey)
               
               if let navCtrl = self.storyboard?.instantiateInitialViewController()
               {
                   let window = UIApplication.shared.windows.first
                   window?.rootViewController = navCtrl
                   window?.makeKeyAndVisible()
               }
           }
       }
       alertController.addAction(okAction)
       self.present(alertController, animated: true, completion: nil)
    }

}

//MARK: - Text Field Delegate
extension BaseNavController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        textField.endEditing(true)
        return true
    }
}
