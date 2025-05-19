//
//  CoreDataManager.swift
//  YES33
//
//  Created by JIN LEE on 5/19/25.
//
import UIKit
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var context: NSManagedObjectContext = {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {
            fatalError("Could not get AppDelegate for Core Data context.")
        }
        return appDelegate.persistentContainer.viewContext
    }()
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                print("CoreData: Context saved successfully.")
            } catch {
                print("CoreData: No changes to save.")
            }
        }
    }
    
    func saveBookToBookCart(bookData: Document) {
        
        let bookCartEntity = BookCart(context: context)
        
        bookCartEntity.title = bookData.title
        
        if let authors = bookData.authors {
            do {
                let jsonData = try JSONEncoder().encode(authors)
                bookCartEntity.authorsJsonString = String(data: jsonData, encoding: .utf8)
            } catch {
                print("Failed to encode authors: \(error)")
            }
        }
        
        bookCartEntity.thumbnail = bookData.thumbnail
        
        if let price = bookData.price {
            bookCartEntity.price = (Int64(price)) as NSNumber // Int? -> Int64
        }
        
        bookCartEntity.contents = bookData.contents
        
        saveContext()
    }
    
    func saveBookToRecentlyViewedBook(bookData: Document) {
        
        let RecentlyViewedBookEntity = RecentlyViewedBook(context: context)
        
        RecentlyViewedBookEntity.title = bookData.title
        
        if let authors = bookData.authors {
            do {
                let jsonData = try JSONEncoder().encode(authors)
                RecentlyViewedBookEntity.authorsJsonString = String(data: jsonData, encoding: .utf8)
            } catch {
                print("Failed to encode authors: \(error)")
            }
        }
        
        RecentlyViewedBookEntity.thumbnail = bookData.thumbnail
        
        if let price = bookData.price {
            RecentlyViewedBookEntity.price = (Int64(price)) as NSNumber // Int? -> Int64
        }
        
        RecentlyViewedBookEntity.contents = bookData.contents
    
        saveContext()
    }
}
