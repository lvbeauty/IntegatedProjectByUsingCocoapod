//
//  ForgetPasswordViewController.swift
//  Touch Novel
//
//  Created by Tong Yi on 5/24/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

class ForgetPasswordViewController: BaseNavController
{
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var newPasswordTF: UITextField!
    @IBOutlet weak var repeatPasswordTF: UITextField!
    @IBOutlet weak var emailImageView: UIImageView!
    @IBOutlet weak var keyImageView: UIImageView!
    @IBOutlet weak var savePasswordButton: UIButton!
    @IBOutlet weak var repeatKeyImageView: UIImageView!
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupUI()
        setupIBOutlet()
    }
    
    //MARK: - Private Setup Methods
    
    private func setupIBOutlet()
    {
        let white = AppConstants.Colors.white
        let textFieldKeys = AppConstants.TextField.self
        emailTF.attributedPlaceholder = NSAttributedString(string: textFieldKeys.emailPL, attributes: [NSAttributedString.Key.foregroundColor: white])
        newPasswordTF.attributedPlaceholder = NSAttributedString(string: textFieldKeys.newPasswordPL, attributes: [NSAttributedString.Key.foregroundColor: white])
        repeatPasswordTF.attributedPlaceholder = NSAttributedString(string: textFieldKeys.repeatPasswordPL, attributes: [NSAttributedString.Key.foregroundColor: white])
        
    }
    
    private func setupUI()
    {
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = "Reset Password"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.view.setGradientBackground(colorOne: AppConstants.Colors.orangePink,
                                        colorTwo: AppConstants.Colors.lightPink,
                                        colorThree: AppConstants.Colors.pink)
        
        CustomTextField.roundBorder(emailTF)
        emailTF.delegate = self
        CustomTextField.roundBorder(newPasswordTF)
        newPasswordTF.isUserInteractionEnabled = false
        newPasswordTF.delegate = self
        CustomTextField.roundBorder(repeatPasswordTF)
        repeatPasswordTF.isUserInteractionEnabled = false
        repeatPasswordTF.delegate = self
        
        emailImageView.roundedImageView()
        keyImageView.roundedImageView()
        repeatKeyImageView.roundedImageView()
        
        CustomButton.roundBorderButton(savePasswordButton)
        
    }

    @IBAction func sentButtonTapped(_ sender: Any)
    {
        guard let email = emailTF.text, email == UserDefaults.standard.value(forKey: AppConstants.UD.email) as! String
        else { alert("Please Enter A vaild Email!"); return }
        
        newPasswordTF.isUserInteractionEnabled = true; repeatPasswordTF.isUserInteractionEnabled = true
        emailTF.endEditing(true)
        newPasswordTF.becomeFirstResponder()
    }
    
    @IBAction func savePasswordButtonTapped(_ sender: UIButton)
    {
        //check for empty
        guard let password = newPasswordTF.text, let repeatPassword = repeatPasswordTF.text else { return }
        
        if password.isEmpty || repeatPassword.isEmpty
        {
            alert("All Fields Are Required!")
        }
        
        //Check if password match
        if password != repeatPassword
        {
            alert("Password do not match!")
        }
        
        //Store data
        UserDefaults.standard.set(password, forKey: AppConstants.UD.password)

        //Display successfully message
        cheer("Reset Password Successfully!")
        
    }
}
