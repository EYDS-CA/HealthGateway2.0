//
//  POCTabBarController.swift
//  HealthGatewayTest
//
//  Created by Amir Shayegh on 2023-02-17.
//

import UIKit

class POCTabBarController: UITabBarController {
    
    class func construct() -> POCTabBarController {
        if let vc =  UIStoryboard(name: "POCTabBar", bundle: nil).instantiateViewController(withIdentifier: String(describing: POCTabBarController.self)) as? POCTabBarController {
            return vc
        }
        return POCTabBarController()
    }
    
    private var previousSelectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup(selectedIndex: 0)
    }
    
    private func setup(selectedIndex: Int) {
        self.tabBar.tintColor = AppColours.appBlue
        self.tabBar.barTintColor = .white
        self.delegate = self
        self.viewControllers = setViewControllers(tabs: POCTabs.allCases)
    }
    
    private func setViewControllers(tabs: [POCTabs]) -> [UIViewController] {
        var viewControllers: [UIViewController] = []
        tabs.forEach { vc in
            guard let properties = vc.properties  else { return }
            let tabBarItem = UITabBarItem(title: properties.title, image: properties.unselectedTabBarImage, selectedImage: properties.selectedTabBarImage)
            tabBarItem.setTitleTextAttributes([.font: UIFont.bcSansBoldWithSize(size: 10)], for: .normal)
            let viewController = properties.baseViewController
            viewController.tabBarItem = tabBarItem
            viewController.title = properties.title
            let navController = CustomNavigationController.init(rootViewController: viewController)
            viewControllers.append(navController)
        }
        return viewControllers
    }
}

extension POCTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // Save the previously selected index, so that we can check if the tab was selected again
        self.previousSelectedIndex = tabBarController.selectedIndex
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        NotificationCenter.default.post(name: .tabChanged, object: nil, userInfo: ["viewController": viewController])
    }
}
