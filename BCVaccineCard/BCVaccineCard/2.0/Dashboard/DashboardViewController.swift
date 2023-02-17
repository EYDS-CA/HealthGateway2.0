//
//  DashboardViewController.swift
//  BCVaccineCard
//
//  Created by Amir Shayegh on 2023-02-17.
//

import UIKit

class DashboardViewController: UIViewController {
    
    class func construct() -> DashboardViewController {
        if let vc = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(withIdentifier: String(describing: DashboardViewController.self)) as? DashboardViewController {
            return vc
        }
        return DashboardViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
