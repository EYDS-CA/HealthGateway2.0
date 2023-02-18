//
//  HealthChecksViewController.swift
//  BCVaccineCard
//
//  Created by Amir Shayegh on 2023-02-17.
//

import UIKit
import MapKit

class SrviceFinderViewController: UIViewController {
    
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var mapToolsContainer: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var seeAllLabel: UILabel!
    @IBOutlet weak var filterIcon: UIButton!
    @IBOutlet weak var listIcon: UIButton!
    @IBOutlet weak var walkInClinicSettingIcon: UIButton!
    
    @IBOutlet weak var walkInClinicLabel: UIView!
    
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    class func construct() -> SrviceFinderViewController {
        if let vc = UIStoryboard(name: "SrviceFinder", bundle: nil).instantiateViewController(withIdentifier: String(describing: SrviceFinderViewController.self)) as? SrviceFinderViewController {
            return vc
        }
        return SrviceFinderViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        style()
    }
    
    func style() {
        
    }

}
