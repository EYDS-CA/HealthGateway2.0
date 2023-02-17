//
//  CareNavigatorViewController.swift
//  BCVaccineCard
//
//  Created by Amir Shayegh on 2023-02-17.
//

import UIKit

class CareNavigatorViewController: UIViewController {
    
    class func construct() -> CareNavigatorViewController {
        if let vc = UIStoryboard(name: "CareNavigator", bundle: nil).instantiateViewController(withIdentifier: String(describing: CareNavigatorViewController.self)) as? CareNavigatorViewController {
            return vc
        }
        return CareNavigatorViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
