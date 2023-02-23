//
//  ServiceFinderDashboardTableViewCell.swift
//  BCVaccineCard
//
//  Created by Amir Shayegh on 2023-02-23.
//

import UIKit
import MapKit

class ServiceFinderDashboardTableViewCell: BaseDashboardTableViewCell {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var transparentContainer: UIView!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var ServiceFinderLabel: UILabel!
    
    func setup() {
        style()
        setupMap()
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
        transparentContainer.isUserInteractionEnabled = true
        transparentContainer.addGestureRecognizer(tap1)
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
    }
    
    func setupMap() {
        
    }
    
}
