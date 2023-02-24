//
//  ContactDashboardTableViewCell.swift
//  BCVaccineCard
//
//  Created by Amir Shayegh on 2023-02-23.
//

import UIKit

class ContactDashboardTableViewCell: BaseDashboardTableViewCell {
    
    @IBOutlet weak var container: UIView!
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
        container.layer.cornerRadius = 10.0
        container.clipsToBounds = true
        container.backgroundColor = UIColor(hexString: "#E5F0FF")
        call911Button.configure(type: .call911, owner: self)
        callHealthNavigatorButton.configure(type: .healthNavigator, owner: self)
        connectWithARegisteredNurseButton.configure(type: .registeredNurse, owner: self)
        emailAPharmacistButton.configure(type: .pharmasistAdvice, owner: self)
        emailAnExerciseProfessional.configure(type: .exerciseProfessional, owner: self)
    }
    
    
}

extension ContactDashboardTableViewCell: ButtonViewAction {
    func buttonTapped(type: DashboardButton, connectType: DashboardButton.ConnectType) {
        self.delegate?.tapped(button: type, connectType: connectType)
    }

}
