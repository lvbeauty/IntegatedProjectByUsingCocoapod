//
//  CustomTextField.swift
//  Touch Novel
//
//  Created by Tong Yi on 5/25/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

class CustomTextField
{
    static func roundBorder(_ textField: UITextField)
    {
        textField.layer.cornerRadius = textField.frame.height / 2
        textField.layer.borderWidth = AppConstants.TextField.borderWidth
        textField.layer.borderColor = AppConstants.Colors.white.cgColor
        textField.clipsToBounds = true
    }
}
