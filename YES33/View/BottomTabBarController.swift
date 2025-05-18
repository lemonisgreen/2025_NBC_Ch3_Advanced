//
//  BottomTabBarController.swift
//  YES33
//
//  Created by JIN LEE on 5/12/25.
//

import UIKit

class BottomTabBarController: UITabBarController {
    
    let cartVC = CartViewController()
    let mainVC = MainViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let controllers = [mainVC, cartVC]
        self.viewControllers = controllers.map{UINavigationController(rootViewController: $0)}
        
        setupTabBar()
        configureTabBar()
    }
    
    private func setupTabBar() {
        
        mainVC.tabBarItem = UITabBarItem(title: "책 찾기", image: UIImage(systemName: "book"), tag: 0)
        mainVC.tabBarItem.selectedImage = UIImage(systemName: "book.fill")

        cartVC.tabBarItem = UITabBarItem(title: "장바구니", image: UIImage(systemName: "cart"), tag: 1)
        cartVC.tabBarItem.selectedImage = UIImage(systemName: "cart.fill")
    }
    
    private func configureTabBar() {
        
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .bold)]
        
        UITabBar.appearance().backgroundColor = .systemGray5
        UITabBar.appearance().unselectedItemTintColor = .systemGray
        UITabBar.appearance().tintColor = .black
        UITabBar.appearance().selectedItem?.setTitleTextAttributes(attributes, for: .normal)
    }
}
