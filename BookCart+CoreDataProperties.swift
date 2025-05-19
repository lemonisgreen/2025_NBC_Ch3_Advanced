//
//  BookCart+CoreDataProperties.swift
//  YES33
//
//  Created by JIN LEE on 5/19/25.
//
//

import Foundation
import CoreData


extension BookCart {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookCart> {
        return NSFetchRequest<BookCart>(entityName: "BookCart")
    }

    @NSManaged public var title: String?
    @NSManaged public var thumbnail: String?
    @NSManaged public var price: NSNumber?
    @NSManaged public var authorsJsonString: String?
    @NSManaged public var contents: String?
    @NSManaged public var isbn: String?

}

extension BookCart : Identifiable {

}

extension BookCart {
    public var priceValue: Int? {
        get {
            return self.price?.intValue
        }
        set {
            if let newValue = newValue {
                self.price = NSNumber(value: newValue)
            } else {
                self.price = nil
            }
        }
    }
}

extension BookCart {
    public var authorsArray: [String]? {
        get {
            guard let jsonData = authorsJsonString?.data(using: .utf8) else { return nil }
            return try? JSONDecoder().decode([String].self, from: jsonData)
        }
        set {
            guard let newValue = newValue else {
                authorsJsonString = nil
                return
            }
            if let jsonData = try? JSONEncoder().encode(newValue) {
                authorsJsonString = String(data: jsonData, encoding: .utf8)
            } else {
                authorsJsonString = nil
            }
        }
    }
}
