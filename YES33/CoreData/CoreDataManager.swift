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
    
    func fetchAllBookCartItems() -> [BookCart] {
        let request: NSFetchRequest<BookCart> = BookCart.fetchRequest()

        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            return try context.fetch(request)
        } catch {
            print("CoreData: Failed to fetch BookCart items: \(error)")
            return []
        }
    }

    func fetchAllRecentlyViewedBooks(limit: Int? = nil) -> [RecentlyViewedBook] {
            let request: NSFetchRequest<RecentlyViewedBook> = RecentlyViewedBook.fetchRequest()
            
            // (선택 사항) 정렬 조건 추가: 예) viewedDate 속성이 있다면 내림차순 정렬
            // let sortDescriptor = NSSortDescriptor(key: "viewedDate", ascending: false)
            // request.sortDescriptors = [sortDescriptor]
            
            // (선택 사항) 가져올 개수 제한
            if let fetchLimit = limit {
                request.fetchLimit = fetchLimit
            }
            
            do {
                return try context.fetch(request)
            } catch {
                print("CoreData: Failed to fetch RecentlyViewedBook items: \(error)")
                return []
            }
        }
        
    func deleteAllBookCartItems() {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = BookCart.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try context.execute(deleteRequest)
                saveContext() // NSBatchDeleteRequest는 컨텍스트를 직접 업데이트하지 않을 수 있음
            } catch {
                print("CoreData Error: Failed to delete all BookCart items - \(error)")
            }
        }

        
}
