//
//  LogInViewController.swift
//  Touch Novel
//
//  Created by Tong Yi on 5/24/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

class LogInViewController: BaseNavController
{
    @IBOutlet weak var logInImageView: UIImageView!
    @IBOutlet weak var userNameTF: UITextField!
    {
        didSet {
            let redPlaceholderText = NSAttributedString(
                string: AppConstants.TextField.usernamePL,
                attributes: [NSAttributedString.Key.foregroundColor: AppConstants.Colors.white])
            userNameTF.attributedPlaceholder = redPlaceholderText
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
    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var keyImage: UIImageView!
    @IBOutlet weak var logInButton: UIButton!
    
    //MARK: - View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        
        userNameTF.text = ""
        passwordTF.text = ""
    }
    
    //MARK: Set Up for UIElements
    
    private func setupUI()
    {
        view.setGradientBackground(colorOne: AppConstants.Colors.orangePink,
                                   colorTwo: AppConstants.Colors.lightPink,
                                   colorThree: AppConstants.Colors.pink)
        logInImageView.roundedImageView()
        personImage.roundedImageView()
        keyImage.roundedImageView()
        
        CustomTextField.roundBorder(userNameTF) //extension is better
        userNameTF.delegate = self
        
        CustomTextField.roundBorder(passwordTF)
        passwordTF.delegate = self
        
        CustomButton.roundBorderButton(logInButton)
    }
    
    //MARK: - IBAction
    @IBAction func logInButtonTapped(_ sender: UIButton)
    {
        if userAuthenticated()
        {
            UserDefaults.standard.set(true, forKey: AppConstants.UD.logInKey)

            if let tabCtrl = self.storyboard?.instantiateViewController(identifier: AppConstants.SB.tabBarIdentifier)
            {
                let window = UIApplication.shared.windows.first
                window?.rootViewController = tabCtrl
                window?.makeKeyAndVisible()
            }
        }
        else
        {
            alert("Please Enter Valid Username And Password!")
        }
        
    }
    
    //MARK: - Authoration
    private func userAuthenticated() -> Bool
    {
        guard  let userName = userNameTF.text, let password = passwordTF.text else { return false}
        
        if userName.isEmpty || password.isEmpty
        {
            return false
        }
        
        let authentication = (userName == UserDefaults.standard.value(forKey: AppConstants.UD.userName) as! String) &&
                             (password == UserDefaults.standard.value(forKey: AppConstants.UD.password) as! String)
        
        UserDefaults.standard.set(authentication, forKey: AppConstants.UD.logInKey)
        return authentication
        
    }
}

//MARK: - Text Field Delegate
extension LogInViewController
{
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        guard userNameTF.text == UserDefaults.standard.value(forKey: AppConstants.UD.userName) as? String else { return }
        
        if UserDefaults.standard.bool(forKey: AppConstants.UD.saveProfileImage)
        {
            getImage(imageName: AppConstants.Profile.imageName)
        }
    }
}

// MARK: - get log in Image
extension LogInViewController
{
    func getImage(imageName: String)
    {
       let fileManager = FileManager.default
       let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
       if fileManager.fileExists(atPath: imagePath){
          logInImageView.image = UIImage(contentsOfFile: imagePath)
       }else{
          print("Panic! No Image!")
       }
    }
}
