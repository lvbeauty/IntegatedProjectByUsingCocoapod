//
//  Book+CoreDataProperties.swift
//  
//
//  Created by Tong Yi on 8/4/20.
//
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var title: String?
    @NSManaged public var author: String?
    @NSManaged public var imageURL: URL?
    @NSManaged public var webReaderURL: URL?

}
