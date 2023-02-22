//
//  MapViewController.swift
//  find-clinics
//
//  Created by Amir Shayegh on 2023-02-18.
//

import UIKit
import MapKit

/**
 Add this in info.plist
 <key>NSLocationWhenInUseUsageDescription</key>
    <string>Your location is required for xyz benefits for you</string>
 */

extension MapViewController {
    struct LocationDisabledMessage {
        let title: String
        let message: String
        let openSettingsTitle: String
        let cancelDialogTitle: String
    }
    
    class MapPin: MKPointAnnotation {
        // Unique identifier for this pin
        let id: String
        // Clustering id/ category for pin grouping
        let groupID: String
        // View used for pin
        let view: UIView
        
        let selectionColour: UIColor
        
        init(id: String, groupID: String, location: CLLocation, view: UIView, selectionColour: UIColor) {
            self.id = id
            self.groupID = groupID
            self.view = view
            self.selectionColour = selectionColour
            super.init()
            self.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        }
    }
}

class MapViewController: UIViewController {
    // MARK: Private Variables
    private weak var mapView: MKMapView?
    private var enableLocation: Bool = false
    private var zoomedIntoUserLocation: Bool = false
    var pins: [MapPin] = [MapPin]()
    
    // MARK: Public Variables
    public var locationManager: CLLocationManager?
    // Center of map - Updated as user moves around the map
    public var mapCenter: CLLocationCoordinate2D?
    // Default region radius used when zooming into a location
    public var regionRadius: CLLocationDistance = 1000
    public var userZoomRadius: CLLocationDistance = 1000
    // Latest device location received from GPS
    public var currentLocation: CLLocation?
    // Set message displayed when location permission has been denied
    public var disabledLocationMessage: LocationDisabledMessage = LocationDisabledMessage(title: "Location Access Disabled", message: "We need permission", openSettingsTitle: "Enabled in Settings", cancelDialogTitle: "Continue without enabling")
    
    /// Setup
    /// - Parameters:
    ///   - container: Map View container
    ///   - enableLocation: enable device location display and racking
    public func setupMap(in container: UIView, enableLocation: Bool) {
        self.enableLocation = enableLocation
        let mapView = MKMapView(frame: container.bounds)
        container.addSubview(mapView)
        // TODO: set contraints
        
        self.mapView = mapView
        mapView.delegate = self
        
        if enableLocation {
            setupLocation()
            mapView.showsUserLocation = true
        }
    }
    
    func deselectPins() {
        mapView?.selectedAnnotations.forEach({ mapView?.deselectAnnotation($0, animated: false) })
    }
    
    // MARK: Overridable events
    public func mapMoved(center: CLLocationCoordinate2D) {}
    public func receivedDeviceLocation(location: CLLocation) {}
    public func tapped(pin: MapPin) {}
}

// MARK: Move
extension MapViewController {
    
    /// Move displayed map
    /// - Parameters:
    ///   - latitude: latitude
    ///   - longitude: longitude
    ///   - radiusMeters: controls map's zoom level
    public func moveMapTo(latitude: Double, longitude: Double, radiusMeters: Double? = nil) {
        let radius = radiusMeters ?? regionRadius
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

// MARK: Map Delegates
extension MapViewController: MKMapViewDelegate{
    
    // when map is moved
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.mapCenter = mapView.centerCoordinate
        mapMoved(center: mapView.centerCoordinate)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let pin = annotation as? MapPin else { return nil }
        // 1) Gen reuse id
        let reuseIdentifier = pin.id
        // 2) Deque reusable view (if already created)
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MapPinAnnotationView
        // 3) If not created, create view with reuse id
        if annotationView == nil {
            annotationView = MapPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
            annotationView?.clusteringIdentifier = pin.groupID
            annotationView?.displayPriority = .defaultLow
        } else {
            // 3.1) Else add annotations to existing view
            annotationView?.annotation = annotation
        }
        guard let annotationView = annotationView else {return nil}
        // 4) Add clustering ID
        annotationView.clusteringIdentifier = pin.groupID
        // 5) Add Color
        annotationView.setPin(model: pin)
        
        return annotationView
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let pin = view.annotation as? MapPin else {return}
        pin.view.layer.cornerRadius = pin.view.frame.width / 2
        pin.view.backgroundColor = pin.selectionColour
        tapped(pin: pin)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard let pin = view.annotation as? MapPin else {return}
        pin.view.backgroundColor = .clear
    }
}

// MARK: Location
extension MapViewController: CLLocationManagerDelegate {
    
    // MARK: Location Setup
    private func setupLocation() {
        let locationManager = CLLocationManager()
        self.locationManager = locationManager
        locationManager.delegate = self
        
        // For use when the app is open
        locationManager.requestWhenInUseAuthorization()
    }
    
    // If location services is enabled start updating the users location
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            if manager.authorizationStatus != .denied {
                locationManager?.delegate = self
                locationManager?.desiredAccuracy = kCLLocationAccuracyBest
                locationManager?.startUpdatingLocation()
            } else {
                showLocationDisabledPopUp()
            }
        } else {
            alert(title: "Get a newer phone", message: "or update to ios 14+")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        currentLocation = location
        receivedDeviceLocation(location: location)
        if enableLocation, !zoomedIntoUserLocation {
            focusOnCurrent()
            zoomedIntoUserLocation = true
        }
    }
    
    // Shows a popup to the user if we have been deined access
    private func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: disabledLocationMessage.title,
                                                message: disabledLocationMessage.message,
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: disabledLocationMessage.cancelDialogTitle, style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: disabledLocationMessage.openSettingsTitle, style: .cancel) { (action) in
            SettingsHelper.open(.locationServices)
        }
        alertController.addAction(openAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: Pins
extension MapViewController {
    public func drop(pin: MapPin) {
        remove(pin: pin)
        pins.append(pin)
        mapView?.addAnnotation(pin)
    }
    
    public func remove(pin: MapPin) {
        if let existing = pins.first(where: {$0.id == pin.id}) {
            mapView?.removeAnnotation(existing)
            pins.removeAll(where: {$0.id == pin.id})
        }
        mapView?.removeAnnotation(pin)
    }
}

// MARK: Annottation View
class MapPinAnnotationView: MKAnnotationView {

    // MARK: Initialization
    var pin: MapViewController.MapPin? = nil

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        frame = CGRect(x: 0, y: 0, width: 40, height: 50)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)

        canShowCallout = true
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup
    func setPin(model: MapViewController.MapPin) {
        self.pin = model
        setupUI()
    }
    
    private func setupUI() {
        guard let pin = pin else {return}
        backgroundColor = .clear

        addSubview(pin.view)
        
        pin.view.translatesAutoresizingMaskIntoConstraints = false
        pin.view.heightAnchor.constraint(equalTo: heightAnchor, constant: 0).isActive = true
        pin.view.widthAnchor.constraint(equalTo: widthAnchor, constant: 0).isActive = true
        pin.view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        pin.view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
    }
}
