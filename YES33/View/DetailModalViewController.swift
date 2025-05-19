//
//  DetailModalViewController.swift
//  YES33
//
//  Created by JIN LEE on 5/13/25.
//

import UIKit
import CoreData

class DetailModalViewController: UIViewController {
    
    var selectedBook: Document?
    
    let titleLabel = UILabel()
    let authorsLabel = UILabel()
    let thumbnailImageView = UIImageView()
    let priceLabel = UILabel()
    let contentsLabel = UITextView()
    let cartButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSelectedBookData()
        setupUI()
        configureUI()
    }
    
    private func setupSelectedBookData() {
        guard let book = selectedBook else { return }
        
        titleLabel.text = book.title
        
        if let authorsArray = book.authors, !authorsArray.isEmpty {
            self.authorsLabel.text = authorsArray.joined(separator: ", ")
        } else {
            self.authorsLabel.text = "저자 정보 없음"
        }
        
        priceLabel.text = book.price.map { "도서정가: \($0)원" } ?? "가격 정보 없음"
    
        contentsLabel.text = book.contents
        
        guard let thumbnail = book.thumbnail,
        let url = URL(string: thumbnail) else { return }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.sync {
                        self?.thumbnailImageView.image = image
                    }
                }
            }
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        authorsLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        authorsLabel.textColor = .systemGray
        
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.backgroundColor = .systemGray6
        thumbnailImageView.layer.cornerRadius = 10
        
        priceLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        contentsLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        contentsLabel.isEditable = false
        contentsLabel.isScrollEnabled = true
        contentsLabel.textColor = .black
        
        cartButton.setTitle("책 담기", for: .normal)
        cartButton.setTitleColor(.black, for: .normal)
        cartButton.tintColor = .systemGray5
        cartButton.configuration = .filled()
        cartButton.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
    }
    
    @objc func cartButtonTapped() {
        CoreDataManager.shared.saveBookToBookCart(bookData: selectedBook!)
    }

    private func configureUI() {
        [
            titleLabel,
            authorsLabel,
            thumbnailImageView,
            priceLabel,
            contentsLabel,
            cartButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            authorsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            authorsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            authorsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            thumbnailImageView.topAnchor.constraint(equalTo: authorsLabel.bottomAnchor, constant: 20),
            thumbnailImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            thumbnailImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 450),
            
            priceLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 20),
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            priceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            contentsLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 20),
            contentsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            contentsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            contentsLabel.bottomAnchor.constraint(equalTo: cartButton.topAnchor, constant: -20),
            
            cartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            cartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            cartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            cartButton.heightAnchor.constraint(equalToConstant: 40)
            ])
    }
}
