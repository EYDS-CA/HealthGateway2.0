//
//  AccessFamilyPhysicianTableViewCell.swift
//  BCVaccineCard
//
//  Created by Connor Ogilvie on 2023-02-27.
//

import UIKit

class AccessFamilyPhysicianTableViewCell: BaseDashboardTableViewCell {
    
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var registerButtonView: ButtonView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    private func setup() {
        self.backgroundColor = .clear
        backgroundImageView.layer.cornerRadius = 10
        backgroundImageView.clipsToBounds = true
        backgroundImageView.image = UIImage(named: "access-physician")
        registerButtonView.configure(type: .findPhysitian, owner: self, padding: 15, weight: .bold)
    }
    
}

extension AccessFamilyPhysicianTableViewCell: ButtonViewAction {
    func buttonTapped(type: DashboardButton, connectType: DashboardButton.ConnectType) {
        self.delegate?.tapped(button: type, connectType: connectType)
    }
    
}
