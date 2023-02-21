//
//  POCTabs.swift
//  HealthGatewayTest
//
//  Created by Amir Shayegh on 2023-02-17.
//

import UIKit

enum POCTabs: Int, CaseIterable {
    case Dashboard = 0, ServiceFinder, UnAuthenticatedRecords, AuthenticatedRecords
    
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
        if #available(iOS 13.0, *) {
            switch self {
            case .Dashboard:
                return Properties(title: "Dashboard",
                                  selectedTabBarImage: UIImage(systemName: "house.fill")!,
                                  unselectedTabBarImage: UIImage(systemName: "house")!,
                                  baseViewController: DashboardViewController.construct())
                
            case .ServiceFinder:
                return Properties(title: "Service Finder",
                                  selectedTabBarImage: UIImage(systemName: "map.fill")!,
                                  unselectedTabBarImage: UIImage(systemName: "map")!,
                                  baseViewController: ServiceFinderViewController.construct())
            case .UnAuthenticatedRecords:
                
                return Properties(title: "Records",
                                  selectedTabBarImage: UIImage(systemName: "list.clipboard.fill")!,
                                  unselectedTabBarImage: UIImage(systemName: "list.clipboard")!,
                                  baseViewController: HealthRecordsViewController.constructHealthRecordsViewController())
                
            case .AuthenticatedRecords:
                return Properties(title: "Records",
                                  selectedTabBarImage: UIImage(systemName: "list.clipboard.fill")!,
                                  unselectedTabBarImage: UIImage(systemName: "list.clipboard")!,
                                  baseViewController: UsersListOfRecordsViewController.constructUsersListOfRecordsViewController(patient: StorageService.shared.fetchAuthenticatedPatient(), authenticated: true, navStyle: .singleUser, hasUpdatedUnauthPendingTest: false))
            }
        }
        return nil
    }
}
