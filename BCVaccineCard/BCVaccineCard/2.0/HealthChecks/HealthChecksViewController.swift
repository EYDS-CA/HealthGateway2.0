//
//  HealthChecksViewController.swift
//  BCVaccineCard
//
//  Created by Amir Shayegh on 2023-02-17.
//

import UIKit

class HealthChecksViewController: UIViewController {
    
    class func construct() -> HealthChecksViewController {
        if let vc = UIStoryboard(name: "HealthChecks", bundle: nil).instantiateViewController(withIdentifier: String(describing: HealthChecksViewController.self)) as? HealthChecksViewController {
            return vc
        }
        return HealthChecksViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
