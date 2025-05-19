//
//  CartViewController.swift
//  YES33
//
//  Created by JIN LEE on 5/12/25.
//

import UIKit

class CartViewController: UIViewController {
    
    let cartTitle = UILabel()
    let deleteAllButton = UIButton()
    
    private var bookResults = [Document]()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.3),
            heightDimension: .estimated(200)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
