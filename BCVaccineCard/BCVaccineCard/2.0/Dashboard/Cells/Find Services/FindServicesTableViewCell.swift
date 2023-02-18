//
//  FindServicesTableViewCell.swift
//  HealthGatewayTest
//
//  Created by Amir Shayegh on 2023-02-17.
//

import UIKit

class FindServicesTableViewCell: BaseDashboardTableViewCell , Theme {
   
   
    @IBOutlet weak var immunizeBCView: UIView!
    @IBOutlet weak var ImmunizeBCDescLabel: UILabel!
    @IBOutlet weak var immunizeBCTitleLabel: UILabel!
    @IBOutlet weak var immunizeBCDivider: UIView!
    
    @IBOutlet weak var islandHealthLogo: UIImageView!
    @IBOutlet weak var islandHealthVIew: UIView!
    @IBOutlet weak var islandHealthDescLabel: UILabel!
 
    @IBOutlet weak var remindersButton: UIButton!
    
    func setup() {
        style()
        addGestures()
    }
    
    func addGestures() {
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.islandHealthTap(_:)))
        islandHealthVIew.isUserInteractionEnabled = true
        islandHealthVIew.addGestureRecognizer(tap1)
    }
    
    @objc func islandHealthTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let delegate = delegate else {
            return
        }
        delegate.tapped(button: .servicesNearYou)
    }
    
    @IBAction func getRemindersAction(_ sender: Any) {
        guard let delegate = delegate else {
            return
        }
        delegate.tapped(button: .immunizeBC)
    }
    
    func style() {
        islandHealthLogo.image = UIImage(named: "islandHealthLogo")
        islandHealthDescLabel.text = "Health services and resources near you"
        islandHealthDescLabel.font = UIFont.bcSansRegularWithSize(size: 12)
        islandHealthDescLabel.textColor = .black
        islandHealthVIew.backgroundColor = UIColor.init(hexString: "#EBEBEB")
        islandHealthVIew.layer.cornerRadius = 12
        
        immunizeBCDivider.backgroundColor = AppColours.barYellow
        immunizeBCTitleLabel.font = UIFont.bcSansBoldWithSize(size: 16)
        immunizeBCTitleLabel.text = "Immunize BC"
        immunizeBCTitleLabel.textColor = AppColours.appBlue
        ImmunizeBCDescLabel.font = UIFont.bcSansRegularWithSize(size: 12)
        ImmunizeBCDescLabel.text = "Immunization tools, indormation, and reources."
        ImmunizeBCDescLabel.textColor = .black
        immunizeBCView.backgroundColor = UIColor.init(hexString: "#E5F0FF")
        immunizeBCView.layer.cornerRadius = 12
        
        if #available(iOS 13.0, *) {
            let btnIcon = UIImage.init(systemName: "iphone.gen2.radiowaves.left.and.right", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12))?.withTintColor(AppColours.appBlue)
            style(button: remindersButton, style: .Hollow, title: "Get reminders", image: btnIcon)
        }
        remindersButton.tintColor = AppColours.appBlue
        if let btnTitle = remindersButton.titleLabel {
            btnTitle.font = UIFont.bcSansBoldWithSize(size: 12)
        }
    }
    
}
