//
//  POCTabs.swift
//  HealthGatewayTest
//
//  Created by Amir Shayegh on 2023-02-17.
//

import UIKit

enum POCTabs: Int, CaseIterable {
    case Dashboard = 0, HealthChecks, UnAuthenticatedRecords, AuthenticatedRecords, CareNavigator
    
    var getIndexOfTab: Int {
        return self.rawValue
    }
    
    struct Properties {
        let title: String
        let selectedTabBarImage: UIImage
        let unselectedTabBarImage: UIImage
        let baseViewController: UIViewController
    }
    
    var properties: Properties? {
        switch self {
        case .Dashboard:
            return Properties(title: "Dashboard",
                              selectedTabBarImage: #imageLiteral(resourceName: "home-tab-selected"),// TODO
                              unselectedTabBarImage: #imageLiteral(resourceName: "home-tab-unselected"),// TODO
                              baseViewController: DashboardViewController.construct())
       
        case .HealthChecks:
            return Properties(title: "HealthChecks",
                              selectedTabBarImage: #imageLiteral(resourceName: "passes-tab-selected"),
                              unselectedTabBarImage: #imageLiteral(resourceName: "passes-tab-unselected"),
                              baseViewController: HealthChecksViewController.construct())
        case .UnAuthenticatedRecords:
            return Properties(title: "Records",
                              selectedTabBarImage: #imageLiteral(resourceName: "records-tab-selected"),// TODO
                              unselectedTabBarImage: #imageLiteral(resourceName: "records-tab-unselected"),// TODO
                              baseViewController: HealthRecordsViewController.constructHealthRecordsViewController())
        case .AuthenticatedRecords:
            return Properties(title: "Records",
                              selectedTabBarImage: #imageLiteral(resourceName: "records-tab-selected"),// TODO
                              unselectedTabBarImage: #imageLiteral(resourceName: "records-tab-unselected"),// TODO
                              baseViewController: UsersListOfRecordsViewController.constructUsersListOfRecordsViewController(patient: StorageService.shared.fetchAuthenticatedPatient(), authenticated: true, navStyle: .singleUser, hasUpdatedUnauthPendingTest: false))
        case .CareNavigator:
            return Properties(title: "CareNavigator",
                              selectedTabBarImage: #imageLiteral(resourceName: "dependent-tab-selected"), // TODO
                              unselectedTabBarImage: #imageLiteral(resourceName: "dependent-tab-unselected"), // TODO
                              baseViewController: CareNavigatorViewController.construct())
        }
    }
}
