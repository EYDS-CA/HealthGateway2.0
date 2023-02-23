//
//  StaticImageViewController.swift
//  BCVaccineCard
//
//  Created by Amir Shayegh on 2023-02-21.
//

import UIKit
class BaseStaticImageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let parent = parent?.parent as? POCTabBarController {
            parent.tabBar.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let parent = parent?.parent as? POCTabBarController {
            parent.tabBar.isHidden = false
        }
    }
}

class StaticImageViewController: BaseStaticImageViewController {

    var image: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupImageView() {
        let imageView = UIImageView(frame: view.frame)
        imageView.image = image
        self.view.addSubview(imageView)
        imageView.addEqualSizeContraints(to: self.view, safe: false)
    }
    
}
