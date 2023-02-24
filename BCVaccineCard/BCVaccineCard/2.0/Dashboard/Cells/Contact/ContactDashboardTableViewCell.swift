//
//  ContactDashboardTableViewCell.swift
//  BCVaccineCard
//
//  Created by Amir Shayegh on 2023-02-23.
//

import UIKit

class ContactDashboardTableViewCell: BaseDashboardTableViewCell {
    
    @IBOutlet private weak var call911Button: RowView!
    @IBOutlet private weak var callHealthNavigatorButton: RowView!
    @IBOutlet private weak var connectWithARegisteredNurseButton: RowView!
    @IBOutlet private weak var emailAPharmacistButton: RowView!
    @IBOutlet private weak var emailAnExerciseProfessional: RowView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    func setup() {
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.clipsToBounds = true
        self.contentView.backgroundColor = UIColor(hexString: "#E5F0FF")
        self.call911Button.configure(type: .call911, owner: self)
        self.callHealthNavigatorButton.configure(type: .healthNavigator, owner: self)
        self.connectWithARegisteredNurseButton.configure(type: .registeredNurse, owner: self)
        self.emailAPharmacistButton.configure(type: .pharmasistAdvice, owner: self)
        self.emailAnExerciseProfessional.configure(type: .exerciseProfessional, owner: self)
    }
    
    
}

extension ContactDashboardTableViewCell: ButtonViewAction {
    func buttonTapped(type: DashboardButton, connectType: DashboardButton.ConnectType) {
        self.delegate?.tapped(button: type, connectType: connectType)
    }

}
