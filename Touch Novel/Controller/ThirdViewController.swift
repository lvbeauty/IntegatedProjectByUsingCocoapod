//
//  SecondViewController.swift
//  Touch Novel
//
//  Created by Tong Yi on 5/24/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController
{
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var resetPasswordButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    private let photoPickCtrl = UIImagePickerController()
    let fileManager = FileManager.default
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupUI()
        imgPkrSetUp()
    }
    
    //MARK: Set Up for UIElements
    
    private func setupUI()
    {
        profileImageView.roundedImageView()
        if UserDefaults.standard.bool(forKey: AppConstants.UD.logInKey)
        {
            usernameLabel.text = UserDefaults.standard.object(forKey: AppConstants.UD.userName) as? String
        }
        
        if UserDefaults.standard.bool(forKey: AppConstants.UD.saveProfileImage)
        {
            getImage(imageName: AppConstants.Profile.imageName)
        }
        
        CustomButton.roundBorderButton(resetPasswordButton)
        CustomButton.roundBorderButton(logOutButton)
    }

    @IBAction func resetPasswordButtonTapped(_ sender: UIButton)
    {
        if let viewCtrl = self.storyboard?.instantiateViewController(withIdentifier: AppConstants.SB.resetPasswordId)
        {
            let window = UIApplication.shared.windows.first
            window?.rootViewController = viewCtrl
            window?.makeKeyAndVisible()
        }
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any)
    {
        UserDefaults.standard.set(false, forKey: AppConstants.UD.logInKey)
        
        if let navCtrl = self.storyboard?.instantiateInitialViewController()
        {
            let window = UIApplication.shared.windows.first
            window?.rootViewController = navCtrl
            window?.makeKeyAndVisible()
        }
    }
}

// MARK: - Image Picker and Gesture

extension ThirdViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate
{
    func imgPkrSetUp()
    {
        photoPickCtrl.delegate = self
        photoPickCtrl.allowsEditing = true
        photoPickCtrl.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .savedPhotosAlbum
        profileImageView.isUserInteractionEnabled = true
        let imageGesture = UITapGestureRecognizer(target: self, action: #selector(photoPickButtonTapped(_:)))
        imageGesture.delegate = self
        imageGesture.numberOfTouchesRequired = 1
        imageGesture.numberOfTapsRequired = 1
        profileImageView.addGestureRecognizer(imageGesture)
    }
    
    @objc func photoPickButtonTapped(_ sender: UIImageView) {
        ActionManager.shared.action(photoPickerCtrl: photoPickCtrl, sender: self)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        profileImageView.image = image
        saveImage(imageName: AppConstants.Profile.imageName)
        UserDefaults.standard.set(true, forKey: AppConstants.UD.saveProfileImage)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Write image to Document Directory
extension ThirdViewController
{
    func saveImage(imageName: String)
    {
       //get the image path
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
       //get the image we took with camera
        let image = profileImageView.image!
       //get the PNG data for this image
        let data = image.pngData()
       //store it in the document directory
        fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
    }
    
    func getImage(imageName: String)
    {
       let fileManager = FileManager.default
       let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
       if fileManager.fileExists(atPath: imagePath){
          profileImageView.image = UIImage(contentsOfFile: imagePath)
       }else{
          print("Panic! No Image!")
       }
    }
}

extension ThirdViewController
{
    
}


