//
//  Untitled.swift
//  YES33
//
//  Created by JIN LEE on 5/13/25.
//

import UIKit

class BookCell: UICollectionViewCell {
    static let id = "BookCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with book: Document) {
        guard let thumbnail = book.thumbnail,
              let url = URL(string: thumbnail) else { return }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.sync {
                        self?.imageView.image = image
                    }
                }
            }
        }
    }
    
    func configure(with recentlyViewedBook: RecentlyViewedBook) {
        guard let thumbnail = recentlyViewedBook.thumbnail,
              let url = URL(string: thumbnail) else { return }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.sync {
                        self?.imageView.image = image
                    }
                }
            }
        }
    }
    
}

