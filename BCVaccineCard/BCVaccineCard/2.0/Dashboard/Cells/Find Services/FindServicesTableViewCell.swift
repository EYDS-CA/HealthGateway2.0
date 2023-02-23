//
//  FindServicesTableViewCell.swift
//  HealthGatewayTest
//
//  Created by Amir Shayegh on 2023-02-17.
//

import UIKit

class FindServicesTableViewCell: BaseDashboardTableViewCell {
   
   
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
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.immunizeBCTap(_:)))
        immunizeBCView.isUserInteractionEnabled = true
        immunizeBCView.addGestureRecognizer(tap2)
    }
    
    @objc func islandHealthTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let delegate = delegate else {
            return
        }
        delegate.tapped(button: .servicesNearYou, connectType: .ignore)
    }
    
    @objc func immunizeBCTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let delegate = delegate else {
            return
        }
        delegate.tapped(button: .immunizeBC, connectType: .ignore)
    }
    
    @IBAction func getRemindersAction(_ sender: Any) {
        guard let delegate = delegate else {
            return
        }
        delegate.tapped(button: .appointmentReminders, connectType: .ignore)
    }
    
    func style() {
        islandHealthLogo.image = UIImage(named: "islandHealthLogo")
        islandHealthDescLabel.text = "Health services and resources near you"
        styleCell(text: islandHealthDescLabel)
        
        islandHealthVIew.backgroundColor = UIColor.init(hexString: "#EBEBEB")
        islandHealthVIew.layer.cornerRadius = 12
        
        immunizeBCDivider.backgroundColor = AppColours.barYellow
        styleCell(title: immunizeBCTitleLabel)
        immunizeBCTitleLabel.text = "Immunize BC"
        styleCell(text: ImmunizeBCDescLabel)
        ImmunizeBCDescLabel.text = "Immunization tools, indormation, and reources."
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
