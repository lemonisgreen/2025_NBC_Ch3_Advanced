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
        
    }
    
    private func setupTabBar() {
        cartVC.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: ""), tag: <#T##Int#>)
        viewControllers = [
            UINavigationController(rootViewController: mainVC),
            UINavigationController(rootViewController: cartVC)
        ]
    }
}
