//
//  DataModel.swift
//  Touch Novel
//
//  Created by Tong Yi on 5/25/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import Foundation

struct DataModel
{
    //MARK: - data model for reading list
    struct ReadingList: Codable
    {
        var imageUrl: URL?
        var bookTitle: String
    }
    
    struct Novel: Codable
    {
        var title: String
        var author: String
        var imageUrl: URL?
        var webReaderUrl: URL?
    }
    
    struct ImageSizeUrl: Codable
    {
        var small: URL?
        var normal: URL?
        
        enum CodingKeys: String, CodingKey
        {
            case small = "smallThumbnail"
            case normal = "thumbnail"
        }
    }
    
    struct Volume: Codable
    {
        var volumeInfo: Novel
    }
    
    struct Novels: Codable
    {
        var items: [Volume]
    }
    
    enum Model
    {
        case view
        case select
    }
}


