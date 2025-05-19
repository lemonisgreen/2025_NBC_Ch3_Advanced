//
//  RecentlyViewedBook+CoreDataProperties.swift
//  YES33
//
//  Created by JIN LEE on 5/19/25.
//
//

import Foundation
import CoreData


extension RecentlyViewedBook {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecentlyViewedBook> {
        return NSFetchRequest<RecentlyViewedBook>(entityName: "RecentlyViewedBook")
    }

    @NSManaged public var thumbnail: String?
    @NSManaged public var authorsJsonString: String?
    @NSManaged public var price: NSNumber?
    @NSManaged public var contents: String?
    @NSManaged public var title: String?
    @NSManaged public var isbn: String?

}

extension RecentlyViewedBook : Identifiable {

}

extension RecentlyViewedBook {
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

extension RecentlyViewedBook {
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
