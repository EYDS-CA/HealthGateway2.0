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
        userZoomRadius = 5000
        setupMap(in: mapContainer, enableLocation: true)
        dropDummyPins()
        style()
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
                let marker = generator.generateMaker(image: UIImage.init(named: "pin-head"), bgColour: UIColor(hexString: "#ebe6e6"))
                let pin = MapPin(id: "van-\(i)", groupID: "1", location: pinLocation, view: marker, selectionColour: AppColours.appBlue)
                drop(pin: pin)
            }
            
            for i in 0...20 {
                let pinLocation = generator.generateRandomVictoriaLocation()
                print(pinLocation)
                let marker = generator.generateMaker(image: UIImage.init(named: "pin-head"), bgColour: UIColor(hexString: "#ebe6e6"))
                let pin = MapPin(id: "vic-\(i)", groupID: "1", location: pinLocation, view: marker, selectionColour: AppColours.appBlue)
                drop(pin: pin)
            }
        }
    }
    
    override func tapped(pin: MapViewController.MapPin) {
        print(pin)
        moveMapTo(latitude: pin.coordinate.latitude, longitude: pin.coordinate.longitude)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.showDetail(pin: pin)
        })
        
    }
    
    override func receivedDeviceLocation(location: CLLocation) {
        var distances: [Double] = []
        for pin in pins {
            let pinlocation = CLLocation(latitude: pin.coordinate.latitude, longitude: pin.coordinate.longitude)
            let distance = pinlocation.distance(from: location)
            distances.append(distance)
        }
        let sortedDistances = distances.sorted()
        if let shortest = sortedDistances.first, shortest > userZoomRadius {
            userZoomRadius = shortest
            userZoomRadius = shortest
            focusOnCurrent()
        }
    }
    
    func style() {
        if let tabBarController = tabBarController {
            tabBarController.tabBar.isHidden = false
            tabBarController.loadViewIfNeeded()
        }
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
        layoutIfNeeded()
    }
    
    
    func showDetail(pin: MapViewController.MapPin) {
        show(route: .PinDetail, withNavigation: true)
        deselectPins()
    }
}
