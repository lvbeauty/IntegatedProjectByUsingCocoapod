//
//  CollectionCellViewModel.swift
//  Touch Novel
//
//  Created by Tong Yi on 5/28/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

struct CollectionCellViewModel
{
    struct Novel: Codable
    {
        var title: String
        var author: String
        var imageUrl: URL?
        var webReaderUrl: URL?
    }
}
