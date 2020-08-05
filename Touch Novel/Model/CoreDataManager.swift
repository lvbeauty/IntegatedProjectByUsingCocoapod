//
//  CoreDataManager.swift
//  Touch Novel
//
//  Created by Tong Yi on 8/4/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager
{
    static let shared = CoreDataManager()
    var fetchedResultController: NSFetchedResultsController<NSFetchRequestResult>!
    var moc: NSManagedObjectContext!
    var booksMo = [Book]()
    typealias Handler = () -> ()
    
    private init() { moc = persistentContainer.viewContext }
    
    // MARK: - Core Data stack
    
    private lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "FavoriteBooks")
        
        if let url = container.persistentStoreDescriptions.first?.url {
            print(url)
            let description = NSPersistentStoreDescription(url: url)
            description.shouldMigrateStoreAutomatically = true
            description.shouldInferMappingModelAutomatically = true
            container.persistentStoreDescriptions = [description]
        }
    
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    private func saveContext () {
        if moc.hasChanges {
            do {
                try moc.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    //MARK: - CRUD
    
    func fetchObj(sortKey: String? = nil, selectedScopeIndx: Int? = nil, searchText: String? = nil) {
        let bookSort = NSSortDescriptor(key: sortKey ?? "title", ascending: true)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
        fetchRequest.sortDescriptors = [bookSort]
        fetchRequest.returnsObjectsAsFaults = true
        
        if let index = selectedScopeIndx, let searchText = searchText
        {
            var filterKeyword = ""
            switch index {
            case 0:
                filterKeyword = "title"
            default:
                filterKeyword = "author"
            }

            fetchRequest.predicate = NSPredicate(format: "\(filterKeyword) contains[c] '\(searchText)'")
        }
        
        self.fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        do
        {
            try self.fetchedResultController.performFetch()
        }
        catch
        {
            fatalError("Failed to initialize FetchResultController: \(error.localizedDescription)")
        }
    }
    
    func fetchBooksThroughBookTitle(title: String, handler: (Book) -> Void) {
        
        let updateRequest = NSFetchRequest<Book>(entityName: "Book")
        updateRequest.predicate = NSPredicate(format: "title = %@", "\(title)")
        var books: [Book]!
        do
        {
            books = try moc.fetch(updateRequest)
        }
        catch
        {
            print(error.localizedDescription)
        }
        
        guard let book = books.first else { return }
        handler(book)
    }
    
    func addBook(title: String?, author: String?, image: URL?, webReader: URL?, sender: UIViewController?)
    {
        let book = Book(context: moc)
        book.title = title
        book.author = author
        book.imageURL = image
        book.webReaderURL = webReader
        
        saveContext()
        
        guard let sender = sender else { return }
        AlertManager.shared.alert("CONGRATULATION!", "This Book Has Been Added to Your Reading List Successfully!", sender: sender)
    }
    
    func loadBooks(handler: ((Book) -> ())? = nil)
    {
        do
        {
            let request = NSFetchRequest<Book>(entityName: "Book")
            booksMo = try moc.fetch(request)
            
            for book in booksMo
            {
                handler?(book)
            }
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
    
    func deleteBook(title: String, completeState: Bool = true)
    {
        fetchBooksThroughBookTitle(title: title) { (book) in
            moc.delete(book)
            
            if completeState
            {
                saveContext()
            }
        }
    }
}
