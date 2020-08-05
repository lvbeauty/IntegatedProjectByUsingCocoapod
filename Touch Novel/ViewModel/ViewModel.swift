//
//  CollectionCellViewModel.swift
//  Touch Novel
//
//  Created by Tong Yi on 5/28/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

class ViewModel {
    
    private let coreDataManager = CoreDataManager.shared
    var updateHandler: () -> () = {}
    typealias Handler = () -> ()
    
    init() { setupCoreDataManager() }
    
    private func setupCoreDataManager()
    {
        coreDataManager.fetchObj()
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
    
    func fetchObj(sortKey: String? = nil, selectedScopeIndx: Int? = nil, searchText: String? = nil)
    {
        coreDataManager.fetchObj(sortKey: sortKey, selectedScopeIndx: selectedScopeIndx, searchText: searchText)
    }
    
    //MARK: - CRUD
    
    func addBook(title: String, author: String, image: URL?, webReader: URL?, sender: UIViewController?) {
        coreDataManager.addBook(title: title, author: author, image: image, webReader: webReader, sender: sender)
    }
    
    func deleteBook(title: String, completeState: Bool = true) {
        coreDataManager.deleteBook(title: title, completeState: completeState)
    }
    
    func refreshData(sortKey: String? = nil)
    {
        coreDataManager.fetchObj()
        updateHandler()
    }
}
