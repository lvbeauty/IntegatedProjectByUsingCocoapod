//
//  Utilities.swift
//  Touch Novel
//
//  Created by Tong Yi on 5/25/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

class ActionManager
{
    static let shared = ActionManager()
    private init() {}
    
    func action(photoPickerCtrl: UIImagePickerController, sender: UIViewController)
    {
        let alertController = UIAlertController(title: "Photo Source", message: "Please Choose a Source", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            photoPickerCtrl.sourceType = .camera
            sender.present(photoPickerCtrl, animated: true)
        }
        let albumAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
            photoPickerCtrl.sourceType = .photoLibrary
            sender.present(photoPickerCtrl, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(albumAction)
        alertController.addAction(cancelAction)
        
        sender.present(alertController, animated: true, completion: nil)
    }
}
