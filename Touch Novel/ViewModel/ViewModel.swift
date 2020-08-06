//
//  CollectionCellViewModel.swift
//  Touch Novel
//
//  Created by Tong Yi on 5/28/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit
import CoreData

class ViewModel {
    
    private let coreDataManager = CoreDataManager.shared
    var updateHandler: () -> () = {}
    typealias Handler = () -> ()
    
    init(entityName: String? = nil) { setupCoreDataManager(entityName: entityName) }
    
    private func setupCoreDataManager(entityName: String? = nil)
    {
        coreDataManager.fetchObj(entityName: entityName)
        coreDataManager.loadBooks()
    }
    
    func numberOfItems(at section: Int) -> Int
    {
        let sections = coreDataManager.fetchedResultController.sections!
        let sectionInfo = sections[section]
        
        return sectionInfo.numberOfObjects
    }
    
    func bookObject(at indexPath: IndexPath) -> Book
    {
        let book = coreDataManager.fetchedResultController.object(at: indexPath) as! Book
        return book
    }
    
    func favoriteBookObject(at indexPath: IndexPath) -> FavoriteBook
    {
        let book = coreDataManager.fetchedResultController.object(at: indexPath) as! FavoriteBook
        return book
    }
    
    func fetchObj(sortKey: String? = nil, entityName: String? = nil, selectedScopeIndx: Int? = nil, searchText: String? = nil)
    {
        coreDataManager.fetchObj(sortKey: sortKey, entityName: entityName, selectedScopeIndx: selectedScopeIndx, searchText: searchText)
    }
    
    //MARK: - CRUD
    
    func addBook(title: String, author: String, image: URL?, webReader: URL?, entityName: String? = nil, sender: UIViewController?) {
        coreDataManager.addBook(title: title, author: author, image: image, webReader: webReader, entityName: entityName, sender: sender)
    }
    
    func deleteBook(title: String, entityName: String? = nil, completeState: Bool = true) {
        coreDataManager.deleteBook(title: title, entityName: entityName, completeState: completeState)
    }
    
    func fetchBooksThroughBookTitle(title: String, entityName: String? = nil, handler: (NSManagedObject) -> Void) {
        coreDataManager.fetchBooksThroughBookTitle(title: title, entityName: entityName, handler: handler)
    }
    
    func refreshData(entityName: String? = nil, sortKey: String? = nil)
    {
        coreDataManager.fetchObj(entityName: entityName)
        updateHandler()
    }
}
