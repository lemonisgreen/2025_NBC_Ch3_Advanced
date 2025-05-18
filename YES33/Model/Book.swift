//
//  Untitled.swift
//  YES33
//
//  Created by JIN LEE on 5/13/25.
//

import Foundation

struct BookResponse: Codable {
    let meta: Meta
    let documents: [Document]
}

struct Meta: Codable {
    let totalCount: Int?
    let pageableCount: Int?
    let isEnd: Bool?
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case pageableCount = "pageable_count"
        case isEnd = "is_end"
    }
}

struct Document: Codable {
    let title: String?
    let contents: String?
    let url: String?
    let isbn: String?
    let datetime: String?
    let authors: [String]?
    let publisher: String?
    let translators: [String]?
    let price: Int?
    let salePrice: Int?
    let thumbnail: String?
    let status: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case contents
        case url
        case isbn
        case datetime
        case authors
        case publisher
        case translators
        case price
        case salePrice = "sale_price"
        case thumbnail
        case status
    }
}
