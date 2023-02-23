//
//  ServiceFinderDashboardTableViewCell.swift
//  BCVaccineCard
//
//  Created by Amir Shayegh on 2023-02-23.
//

import UIKit
import MapKit
import CoreLocation

class ServiceFinderDashboardTableViewCell: BaseDashboardTableViewCell {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var transparentContainer: UIView!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var ServiceFinderLabel: UILabel!
    @IBOutlet weak var permissionContainer: UIView!
    @IBOutlet weak var enableLabel: UILabel!
    @IBOutlet weak var enableButton: UIButton!
    
    public var locationManager: CLLocationManager?
    public var userZoomRadius: CLLocationDistance = 500
    public var currentLocation: CLLocation?
    fileprivate var zoomedIntoUserLocation: Bool = false
    
    func setup() {
        style()
        setupLocation()
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
        transparentContainer.isUserInteractionEnabled = true
        transparentContainer.addGestureRecognizer(tap1)
        
        moveMapTo(latitude: 54.623482, longitude: -125.788233, radiusMeters: 1000000)
    }
    
    @objc func onTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let delegate = delegate else {
            return
        }
        delegate.tapped(button: .serviceFinder)
    }
    
    func style() {
        ServiceFinderLabel.font = UIFont.bcSansBoldWithSize(size: 13)
        ServiceFinderLabel.textColor = AppColours.appBlue
        arrowImageView.tintColor = AppColours.appBlue
        permissionContainer.clipsToBounds = true
        permissionContainer.layer.cornerRadius = 10
        style(button: enableButton, style: .Fill, title: "Enable", image: nil)
        enableLabel.font = UIFont.bcSansBoldWithSize(size: 13)
        makeTransparentBlur(view: transparentContainer)
        makeTransparentBlur(view: permissionContainer)
        permissionContainer.backgroundColor = UIColor.white.withAlphaComponent(0.8)
    }
    
    func makeTransparentBlur(view: UIView) {
        view.backgroundColor = .clear
        let tag = 09124
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.8
        view.viewWithTag(tag)?.removeFromSuperview()
        blurEffectView.tag = tag
        view.insertSubview(blurEffectView, at: 0)
    }
    
    
    @IBAction func enableAction(_ sender: Any) {
        if #available(iOS 14.0, *) {
            if locationManager?.authorizationStatus == .denied {
                SettingsHelper.open(.locationServices)
            } else {
                askForAuthorization()
            }
        }
    }
}

extension ServiceFinderDashboardTableViewCell: CLLocationManagerDelegate {
    
    // MARK: Location
   
    // If location services is enabled start updating the users location
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            if manager.authorizationStatus != .denied {
                locationManager?.delegate = self
                locationManager?.desiredAccuracy = kCLLocationAccuracyBest
                locationManager?.startUpdatingLocation()
            } else {
                setPermissionLayerBasedOnAuthorization()
            }
        } else {
            enableLabel.text = "Upgrade to iOS 14 or higher to use this feaure"
        }
        setPermissionLayerBasedOnAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        currentLocation = location
        if !zoomedIntoUserLocation {
            focusOnCurrent()
            zoomedIntoUserLocation = true
        }
    }
    
    func setPermissionLayerBasedOnAuthorization() {
        if #available(iOS 14.0, *) {
            switch locationManager?.authorizationStatus {
            case .notDetermined, .denied:
                showPermissionLayer()
            case .restricted, .authorizedAlways, .authorizedWhenInUse:
                hidePermissionLayer()
            @unknown default:
                showPermissionLayer()
            }
        }
    }
    
    func showPermissionLayer() {
        permissionContainer.alpha = 1
    }
    
    func hidePermissionLayer() {
        permissionContainer.alpha = 0
    }
    
    func setupLocation() {
        mapView.showsUserLocation = true
        let locationManager = CLLocationManager()
        self.locationManager = locationManager
        locationManager.delegate = self
        setPermissionLayerBasedOnAuthorization()
    }
    
    func askForAuthorization() {
        locationManager?.requestWhenInUseAuthorization()
    }
    
}

// MARK: Move
extension ServiceFinderDashboardTableViewCell {
    
    /// Move displayed map
    /// - Parameters:
    ///   - latitude: latitude
    ///   - longitude: longitude
    ///   - radiusMeters: controls map's zoom level
    public func moveMapTo(latitude: Double, longitude: Double, radiusMeters: Double? = nil) {
        let radius = radiusMeters ?? 1000
        let loc = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let coordinateRegion = MKCoordinateRegion.init(center: loc,latitudinalMeters: radius * 2.0, longitudinalMeters: radius * 2.0)
        mapView?.setRegion(coordinateRegion, animated: true)
    }
    
    /// Move map center to device's current position. uses regionRadius variable for radius
    public func focusOnCurrent() {
        guard let location = locationManager?.location?.coordinate else { return }
        moveMapTo(latitude: location.latitude, longitude: location.longitude, radiusMeters: userZoomRadius)
    }
}
