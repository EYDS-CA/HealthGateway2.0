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
    
    private let authManager = AuthManager()
    private var authWorker: AuthenticatedHealthRecordsAPIWorker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authWorker = AuthenticatedHealthRecordsAPIWorker(delegateOwner: self)
        BaseURLWorker.setup(BaseURLWorker.Config(delegateOwner: self))
        self.setup(selectedIndex: 0)
        
        // When authentication status changes, we can set the records tab to the appropriate VC
        // and fetch records
        AppStates.shared.listenToAuth { authenticated in
            self.setTabs()
            self.syncRecordsIfNeeded()
        }
        
        // Local auth happens on records tab only.
        // When its done, we should fetch records if user is authenticated.
        AppStates.shared.listenLocalAuth {
            self.syncRecordsIfNeeded()
        }
    }
    
    private func setup(selectedIndex: Int) {
        self.tabBar.tintColor = AppColours.appBlue
        self.tabBar.barTintColor = .white
        setTabs()
    }
    
    func syncRecordsIfNeeded() {
        guard authManager.isAuthenticated else {return}
        guard let authToken = authManager.authToken, let hdid = authManager.hdid else { return }
        let authCreds = AuthenticationRequestObject(authToken: authToken, hdid: hdid)
        CommentService(network: AFNetwork(), authManager: AuthManager()).submitUnsyncedComments {
            self.authWorker?.getAuthenticatedPatientDetails(authCredentials: authCreds, showBanner: false, isManualFetch: false, protectiveWord: AuthManager().protectiveWord,sourceVC: .BackgroundFetch)
        }
    }
    
    private func setTabs() {
        if AuthManager().isAuthenticated {
            self.viewControllers = setViewControllers(tabs: authenticatedTabs())
        } else {
            self.viewControllers = setViewControllers(tabs: unAuthenticatedTabs())
        }
    }
    
    func authenticatedTabs() -> [POCTabs] {
        return [.Dashboard, .HealthChecks, .AuthenticatedRecords, .CareNavigator]
    }
    
    func unAuthenticatedTabs() -> [POCTabs] {
        return [.Dashboard, .HealthChecks, .UnAuthenticatedRecords, .CareNavigator]
    }
    
    private func setViewControllers(tabs: [POCTabs]) -> [UIViewController] {
        return tabs.compactMap({setViewController(tab: $0)})
    }
    
    private func setViewController(tab vc: POCTabs) -> UIViewController? {
        guard let properties = vc.properties  else { return nil}
        let tabBarItem = UITabBarItem(title: properties.title, image: properties.unselectedTabBarImage, selectedImage: properties.selectedTabBarImage)
        tabBarItem.setTitleTextAttributes([.font: UIFont.bcSansBoldWithSize(size: 10)], for: .normal)
        let viewController = properties.baseViewController
        viewController.tabBarItem = tabBarItem
        viewController.title = properties.title
        let navController = CustomNavigationController.init(rootViewController: viewController)
        return navController
    }
}
