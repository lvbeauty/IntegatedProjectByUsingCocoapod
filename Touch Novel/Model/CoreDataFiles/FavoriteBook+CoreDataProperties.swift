//
//  FavoriteBook+CoreDataProperties.swift
//  
//
//  Created by Tong Yi on 8/5/20.
//
//

import Foundation
import CoreData


extension FavoriteBook {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteBook> {
        return NSFetchRequest<FavoriteBook>(entityName: "FavoriteBook")
    }

    @NSManaged public var title: String?
    @NSManaged public var author: String?
    @NSManaged public var imageURL: URL?
    @NSManaged public var webReaderURL: URL?

}
