//
//  HealthChecksViewController.swift
//  BCVaccineCard
//
//  Created by Amir Shayegh on 2023-02-17.
//

import UIKit

class ServiceFinderViewController: UIViewController {
    
    class func construct() -> SrviceFinderViewController {
        if let vc = UIStoryboard(name: "SrviceFinder", bundle: nil).instantiateViewController(withIdentifier: String(describing: SrviceFinderViewController.self)) as? SrviceFinderViewController {
            return vc
        }
        return SrviceFinderViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
