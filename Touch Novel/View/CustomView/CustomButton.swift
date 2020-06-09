//
//  CustomButton.swift
//  Touch Novel
//
//  Created by Tong Yi on 5/24/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

class CustomButton
{
    static func roundBorderButton(_ button: UIButton)
    {
        button.layer.cornerRadius = button.frame.height / 2
    }
}
