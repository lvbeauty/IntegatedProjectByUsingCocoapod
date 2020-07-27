//
//  SignUpViewController.swift
//  Touch Novel
//
//  Created by Tong Yi on 5/24/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

class SignUpViewController: BaseNavController
{
    @IBOutlet weak var userNameTF: UITextField!
    {
        didSet {
            let redPlaceholderText = NSAttributedString(
                string: AppConstants.TextField.usernamePL,
                attributes: [NSAttributedString.Key.foregroundColor: AppConstants.Colors.white])
            userNameTF.attributedPlaceholder = redPlaceholderText
        }
    }
    
    @IBOutlet weak var emailTF: UITextField!
    {
        didSet {
            let redPlaceholderText = NSAttributedString(
                string: AppConstants.TextField.emailPL,
                attributes: [NSAttributedString.Key.foregroundColor: AppConstants.Colors.white])
            emailTF.attributedPlaceholder = redPlaceholderText
        }
    }
    
    @IBOutlet weak var passwordTF: UITextField!
    {
        didSet {
            let redPlaceholderText = NSAttributedString(
                string: AppConstants.TextField.passwordPL,
                attributes: [NSAttributedString.Key.foregroundColor: AppConstants.Colors.white])
            passwordTF.attributedPlaceholder = redPlaceholderText
        }
    }
    
    @IBOutlet weak var repeatPasswordTF: UITextField!
    {
        didSet {
            let redPlaceholderText = NSAttributedString(
                string: AppConstants.TextField.repeatPasswordPL,
                attributes: [NSAttributedString.Key.foregroundColor: AppConstants.Colors.white])
            repeatPasswordTF.attributedPlaceholder = redPlaceholderText
        }
    }
    
    @IBOutlet weak var repeatKeyImageView: UIImageView!
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var emailImageView: UIImageView!
    @IBOutlet weak var keyImageView: UIImageView!
    @IBOutlet weak var signUpButton: UIButton!
    
    //MARK: - View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: Set Up for UIElements
    private func setupUI()
    {
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = "Create Account"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.view.setGradientBackground(colorOne: AppConstants.Colors.orangePink,
                                        colorTwo: AppConstants.Colors.lightPink,
                                        colorThree: AppConstants.Colors.pink)
        
        CustomTextField.roundBorder(userNameTF)
        userNameTF.delegate = self
        CustomTextField.roundBorder(emailTF)
        emailTF.delegate = self
        CustomTextField.roundBorder(passwordTF)
        passwordTF.delegate = self
        CustomTextField.roundBorder(repeatPasswordTF)
        repeatPasswordTF.delegate = self
        
        personImageView.roundedImageView()
        emailImageView.roundedImageView()
        keyImageView.roundedImageView()
        repeatKeyImageView.roundedImageView()
        
        CustomButton.roundBorderButton(signUpButton)
    }

    //MARK: - IBAction
    @IBAction func signUpButtonTapped(_ sender: UIButton)
    {
        //check for empty
        guard let userName = userNameTF.text, let email = emailTF.text, let password = passwordTF.text, let repeatPassword = repeatPasswordTF.text else { return }
        
        if userName.isEmpty || email.isEmpty || password.isEmpty || repeatPassword.isEmpty
        {
            alert("All Fields Are Required!")
        }
        else if !isValidEmail(email)
        {
            alert("Please Enter a Valid Email Address!")
        }
        
        //Check if password match
        if password != repeatPassword
        {
            alert("Password do not match!")
        }
        
        //Store data
        UserDefaults.standard.set(userName, forKey: AppConstants.UD.userName)
        UserDefaults.standard.set(email, forKey: AppConstants.UD.email)
        UserDefaults.standard.set(password, forKey: AppConstants.UD.password)
        
        //Display successfully message
        cheer("Sign Up Successfully!")
    }
    
    
    func isValidEmail(_ email: String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    func isValidPassword(_ password: String) -> Bool
    {
        let passwordVaild = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordVaild.evaluate(with: password)
    }
}

