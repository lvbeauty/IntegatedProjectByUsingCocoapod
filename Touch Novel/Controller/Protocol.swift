//
//  Protocol.swift
//  Touch Novel
//
//  Created by Tong Yi on 7/30/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import Foundation

protocol CollectionRowDelegate: class {
    func collectionCellTapped(item: DataModel.Novel)
}
