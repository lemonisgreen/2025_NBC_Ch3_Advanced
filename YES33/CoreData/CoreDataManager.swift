//
//  CoreDataManager.swift
//  YES33
//
//  Created by JIN LEE on 5/19/25.
//

import CoreData

func saveBookToBookCart(bookData: Document, context: NSManagedObjectContext) {
    
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
    
    
    do {
        try context.save()
        print("Book data saved to Core Data successfully!")
    } catch {
        print("Failed to save book data: \(error.localizedDescription)")
    }
}

func saveBookToRecentlyViewedBook(bookData: Document, context: NSManagedObjectContext) {
    
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
    
    
    do {
        try context.save()
        print("Book data saved to Core Data successfully!")
    } catch {
        print("Failed to save book data: \(error.localizedDescription)")
    }
}
