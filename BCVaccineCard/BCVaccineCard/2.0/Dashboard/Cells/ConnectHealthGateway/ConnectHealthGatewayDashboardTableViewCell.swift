//
//  ConnectHealthGatewayDashboardTableViewCell.swift
//  BCVaccineCard
//
//  Created by Amir Shayegh on 2023-02-23.
//

import UIKit

class ConnectHealthGatewayDashboardTableViewCell: BaseDashboardTableViewCell {
    
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var divider: UIView!
    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var descLabel: UILabel!
    func setup() {
        style()
    }
    
    @IBAction func connect(_ sender: Any) {
        delegate?.tapped(button: .connectHealthRecords, connectType: .ignore)
    }
    
    func style() {
        container.layer.cornerRadius = 10
        container.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        titleLabel.text = "Access all your health records through Health Gateway"
        titleLabel.font = UIFont.bcSansBoldWithSize(size: 18)
        titleLabel.textColor = AppColours.appBlue
        divider.backgroundColor = AppColours.barYellow
        descLabel.text = "Health Gateway provides secure and convenient access to your B.C. health records all in one place. Keep track of what's important to you and your health."
        descLabel.font = UIFont.systemFont(ofSize: 13)
        descLabel.textColor = UIColor(red: 0.192, green: 0.192, blue: 0.196, alpha: 1)
        style(button: connectButton, style: .Fill, title: "Connect", image: nil, bold: true)
    }
}
