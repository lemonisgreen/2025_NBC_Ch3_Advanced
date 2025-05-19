//
//  CartViewController.swift
//  YES33
//
//  Created by JIN LEE on 5/12/25.
//

import UIKit
import CoreData

class CartViewController: UIViewController {
    
    let cartTitle = UILabel()
    let deleteAllButton = UIButton(type: .system)
    
    private var cartItems: [BookCart] = []
    
    private lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let screenWidth = UIScreen.main.bounds.width
        let padding: CGFloat = 10
        let availableWidth = screenWidth - (padding * 3)
        let itemWidth = availableWidth / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5 + 60)
        layout.minimumLineSpacing = padding
        layout.minimumInteritemSpacing = padding
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: 20, right: padding)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        cv.register(BookCell.self, forCellWithReuseIdentifier: BookCell.id)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
 
        loadCartItems()
    }
    
    private func setupUI() {
        cartTitle.text = "장바구니"
        cartTitle.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        cartTitle.textAlignment = .center
       
        deleteAllButton.setTitle("전체 삭제", for: .normal)
        deleteAllButton.setTitleColor(.red, for: .normal)
        deleteAllButton.addTarget(self, action: #selector(deleteAllCartItemsTapped), for: .touchUpInside)
    }
    
    private func configureUI() {
        
        [cartTitle, deleteAllButton, collectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
     
            cartTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            cartTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cartTitle.trailingAnchor.constraint(lessThanOrEqualTo: deleteAllButton.leadingAnchor, constant: -8),
            
            deleteAllButton.centerYAnchor.constraint(equalTo: cartTitle.centerYAnchor),
            deleteAllButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            collectionView.topAnchor.constraint(equalTo: cartTitle.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func loadCartItems() {
        cartItems = CoreDataManager.shared.fetchAllBookCartItems()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            if self.cartItems.isEmpty {
                self.deleteAllButton.isEnabled = false
                self.deleteAllButton.alpha = 0.5
            } else {
                self.deleteAllButton.isEnabled = true
                self.deleteAllButton.alpha = 1.0
            }
        }
    }
    
    @objc private func deleteAllCartItemsTapped() {
    
        let alert = UIAlertController(title: "전체 삭제 확인", message: "장바구니의 모든 책을 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { [weak self] _ in
            CoreDataManager.shared.deleteAllBookCartItems()
            self?.loadCartItems()
        }))
        present(alert, animated: true)
    }
}

extension CartViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCell.id, for: indexPath) as? BookCell else {
            fatalError("Unable to dequeue BookCell in CartViewController")
        }
        
        let bookCartItem = cartItems[indexPath.row]

        let documentForCell = Document(
            title: bookCartItem.title,
            contents: bookCartItem.contents,
            url: nil,
            isbn: nil,
            datetime: nil,
            authors: bookCartItem.authorsArray,
            publisher: nil,
            translators: nil,
            price: bookCartItem.priceValue,
            salePrice: nil,
            thumbnail: bookCartItem.thumbnail,
            status: nil
        )
        cell.configure(with: documentForCell)
        return cell
    }
}

extension CartViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < cartItems.count else { return }
        let selectedCartItem = cartItems[indexPath.row]
        
        let documentToShow = Document(
            title: selectedCartItem.title,
            contents: selectedCartItem.contents,
            url: nil,
            isbn: nil,
            datetime: nil,
            authors: selectedCartItem.authorsArray,
            publisher: nil,
            translators: nil,
            price: selectedCartItem.priceValue,
            salePrice: nil,
            thumbnail: selectedCartItem.thumbnail,
            status: nil
        )
        
        let detailModalVC = DetailModalViewController()
        detailModalVC.selectedBook = documentToShow
        detailModalVC.isFromCartView = true // CartViewController에서 호출됨을 알림
        
        self.present(detailModalVC, animated: true, completion: nil)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
