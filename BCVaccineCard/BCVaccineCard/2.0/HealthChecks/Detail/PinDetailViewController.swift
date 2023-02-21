//
//  PinDetailViewController.swift
//  BCVaccineCard
//
//  Created by Amir Shayegh on 2023-02-21.
//

import UIKit

class PinDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let parent = parent?.parent as? POCTabBarController {
            parent.tabBar.isHidden = true
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let parent = parent?.parent as? POCTabBarController {
            parent.tabBar.isHidden = false
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
