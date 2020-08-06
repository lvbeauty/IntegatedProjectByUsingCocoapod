//
//  Extension.swift
//  Touch Novel
//
//  Created by Tong Yi on 5/24/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

//MARK: - Extension for UIImageView
extension UIImageView
{
    func roundedImageView()
    {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}

//MARK: - Extension for UIView
extension UIView
{
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor, colorThree: UIColor)
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor,
                                colorTwo.cgColor,
                                colorThree.cgColor]
        gradientLayer.locations = [0.3, 0.7, 0.8, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

//MARK: - Extension for String Type
extension String
{
    enum ValidityType
    {
        case email
        case password
    }
    
    enum Regex: String
    {
        case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        case password = "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}"
    }
    
//    func isvalid(_ validityType: ValidityType) -> Bool
//    {
//        let format = "SELF MATCHES %@"
//        
//        
//    }
}

extension UIViewController {
    func shadowTabBar() {
        self.tabBarController?.tabBar.backgroundImage = UIImage()
        self.tabBarController?.tabBar.shadowImage = UIImage()
        self.tabBarController?.tabBar.layer.shadowColor = UIColor.orange.cgColor
        self.tabBarController?.tabBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.tabBarController?.tabBar.layer.shadowRadius = 2
        self.tabBarController?.tabBar.layer.shadowOpacity = 0.4
        self.tabBarController?.tabBar.clipsToBounds = true
    }
}
