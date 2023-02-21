//
//  HealthChecksViewController.swift
//  BCVaccineCard
//
//  Created by Amir Shayegh on 2023-02-17.
//

import UIKit
import MapKit

class ServiceFinderViewController: MapViewController {
    
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var mapToolsContainer: UIView!
    @IBOutlet weak var mapContainer: UIView!
    @IBOutlet weak var seeAllLabel: UILabel!
    @IBOutlet weak var filterIcon: UIButton!
    @IBOutlet weak var listIcon: UIButton!
    @IBOutlet weak var walkInClinicSettingIcon: UIButton!
    
    @IBOutlet weak var walkInClinicLabel: UILabel!
    
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    class func construct() -> ServiceFinderViewController {
        if let vc = UIStoryboard(name: "SrviceFinder", bundle: nil).instantiateViewController(withIdentifier: String(describing: ServiceFinderViewController.self)) as? ServiceFinderViewController {
            return vc
        }
        return ServiceFinderViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap(in: mapContainer, enableLocation: true)
        style()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dropDummyPins()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        style()
    }
    
    func dropDummyPins() {
        if #available(iOS 13.0, *) {
            let generator = MarkgerGenerator()
            for i in 0...20 {
                let pinLocation = generator.generateRandomVancouverLocation()
                print(pinLocation)
                let marker = generator.generateMaker(image: UIImage.init(systemName: "heart.circle"), bgColour: UIColor(hexString: "#ebe6e6"))
                let pin = MapPin(id: "\(i)", groupID: "1", location: pinLocation, view: marker)
                drop(pin: pin)
            }
        }
    }
    
    override func tapped(pin: MapViewController.MapPin) {
        print(pin)
        moveMapTo(latitude: pin.coordinate.latitude, longitude: pin.coordinate.longitude)
        showDetail(pin: pin)
    }
    
    func style() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isHidden = true
        mapToolsContainer.backgroundColor = AppColours.appBlue
        locationLabel.text = "Vancouver, BC"
        locationLabel.font = UIFont.bcSansRegularWithSize(size: 15)
        nameLabel.text = AuthManager().displayName ?? "Jean Smith"
        nameLabel.textColor = .white
        nameLabel.font = UIFont.bcSansBoldWithSize(size: 15)
        locationLabel.textColor = .white
        seeAllLabel.textColor = .white
        seeAllLabel.font = UIFont.bcSansRegularWithSize(size: 15)
        walkInClinicLabel.textColor = .white
        walkInClinicLabel.font = UIFont.bcSansBoldWithSize(size: 17)
        userIcon.backgroundColor = .white
        walkInClinicSettingIcon.tintColor = .white
        filterIcon.tintColor = .white
        listIcon.tintColor = .white
        userIcon.layer.cornerRadius = userIcon.frame.height / 2
    }
    
    
    func showDetail(pin: MapViewController.MapPin) {
        showPinDetail(pin: pin)    }
}
