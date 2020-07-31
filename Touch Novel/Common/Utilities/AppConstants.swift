//
//  AppConstants.swift
//  Touch Novel
//
//  Created by Tong Yi on 5/24/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

struct AppConstants
{
    static let noDataToShow = "There is no result in your reading list. \n Please find the books you like in the featured page."
    
    //MARK: - Color constants
    struct Colors
    {
        static let orangePink = UIColor(red: 255.0/255.0, green: 120.0/255.0, blue: 100.0/255.0, alpha: 1)
        static let lightPink  = UIColor.systemPink.withAlphaComponent(0.8)
        static let pink       = UIColor.systemPink.withAlphaComponent(0.9)
        static let white      = UIColor.white
    }

    //MARK: - TextField constants
    struct TextField
    {
        static let borderWidth: CGFloat = 0.6
        static let usernamePL = "User Name"
        static let emailPL = "Email Address"
        static let passwordPL = "Password"
        static let repeatPasswordPL = "Repeat Password"
        static let newPasswordPL = "New Password"
    }

    //MARK: - Storyboard ID and UserDefault Keys
    struct UD
    {
        static let logInKey = "ISUSERLOGGEDIN"
        static let userName = "userName"
        static let email = "email"
        static let password = "password"
        static let profileImage = "ProfileImage"
        static let saveProfileImage = "SaveProfileImage"
    }

    struct SB
    {
        static let loginIdentifier = "LogInViewController"
        static let tabBarIdentifier = "TabBarController"
        static let navIdentifier = "NavigationController"
        static let resetPasswordId = "ForgetPasswordViewController"
        static let webViewSegueId = "showWebViewSegue"
        static let webViewSegueId2 = "showWebViewSegue2"
    }
    
    //MARK: - Cell
    struct Cell
    {
        static let collectionViewCellId = "CollectionCell"
        static let tableViewCellId = "reuseIdentifier"
        static let favoritCollectionCellId = "FavoriteCollectionCell"
    }
    
    //MARK: - Network
    struct Network
    {
        static let urls = [URL(string: "https://www.googleapis.com/books/v1/volumes?q=fiction+novel"),
                           URL(string: "https://www.googleapis.com/books/v1/volumes?q=mysteries+novel"),
                           URL(string: "https://www.googleapis.com/books/v1/volumes?q=fantasy+novel"),
                           URL(string: "https://www.googleapis.com/books/v1/volumes?q=horror+novel"),
                           URL(string: "https://www.googleapis.com/books/v1/volumes?q=romance+novel"),
                           URL(string: "https://www.googleapis.com/books/v1/volumes?q=historical"),
                           URL(string: "https://www.googleapis.com/books/v1/volumes?q=web+novels")]
        
        static let header = "application/json"
        struct JSONKeys
        {
            static let items = "items"
            static let volumeInfo = "volumeInfo"
            static let title = "title"
            static let authors = "authors"
            static let imageLinks = "imageLinks"
            static let small = "smallThumbnail"
            static let normal = "thumbnail"
            static let accessInfo = "accessInfo"
            static let webLink = "webReaderLink"
        }
        
        enum category: String
        {
            case Fiction = "Fiction"
            case Mysteries = "Mysteries"
            case Fantasy = "Fantasy"
            case Horror = "Horror"
            case Romance = "Romance"
            case Historical = "Historical"
        }
        
    }
    
    struct Profile
    {
        static let imageName = "profileImage"
    }
    
}

