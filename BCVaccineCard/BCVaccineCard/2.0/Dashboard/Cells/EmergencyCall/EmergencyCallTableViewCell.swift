//
//  EmergencyCallTableViewCell.swift
//  BCVaccineCard
//
//  Created by Amir Shayegh on 2023-02-24.
//

import UIKit

class EmergencyCallTableViewCell: BaseDashboardTableViewCell {
    
    @IBOutlet private weak var rowView911: RowView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    func setup() {
        rowView911.configure911Row(type: .call911, owner: self)
    }
    
}

extension EmergencyCallTableViewCell: ButtonViewAction {
    func buttonTapped(type: DashboardButton, connectType: DashboardButton.ConnectType) {
        self.delegate?.tapped(button: type, connectType: connectType)
    }
}
