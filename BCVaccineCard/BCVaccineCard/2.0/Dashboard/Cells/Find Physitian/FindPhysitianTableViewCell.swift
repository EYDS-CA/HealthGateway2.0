//
//  FindPhysitianTableViewCell.swift
//  HealthGatewayTest
//
//  Created by Amir Shayegh on 2023-02-17.
//

import UIKit

class FindPhysitianTableViewCell: BaseDashboardTableViewCell {
    
    @IBOutlet private weak var roundedAccessView: UIView!
    @IBOutlet private weak var roundedAccessViewTitleLabel: UILabel!
    @IBOutlet private weak var roundedseparatorView: UIView!
    @IBOutlet private weak var roundeddescriptionLabel: UILabel!
    @IBOutlet private weak var roundedAccessViewButtonImageView: UIImageView!
    @IBOutlet private weak var call911Button: ButtonView!
    @IBOutlet private weak var virtualWalkInButton: ButtonView!
    @IBOutlet private weak var chatButton: ButtonView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setup() {
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.clipsToBounds = true
        self.contentView.backgroundColor = AppColours.appBlueLight
        self.roundedAccessView.layer.cornerRadius = 10.0
        self.roundedAccessView.clipsToBounds = true
        self.roundedAccessView.backgroundColor = AppColours.appBlue
        roundedAccessViewTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        roundedAccessViewTitleLabel.textColor = .white
        roundedAccessViewTitleLabel.text = DashboardButton.findPhysitian.getTitle
        roundedseparatorView.backgroundColor = .systemYellow
        roundeddescriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        roundeddescriptionLabel.textColor = AppColours.textGray
        roundeddescriptionLabel.text = DashboardButton.findPhysitian.getDescription
        self.call911Button.configure(type: .call911, owner: self, rounding: 10)
        self.virtualWalkInButton.configure(type: .virtualWalkIn, owner: self, rounding: 10)
        self.chatButton.configure(type: .chat, owner: self, rounding: 10)
    }
    
    @IBAction private func roundedAccessViewButtonAction(_ sender: UIButton) {
        self.delegate?.tapped(button: .findPhysitian)
    }
}

extension FindPhysitianTableViewCell: ButtonViewAction {
    func buttonTapped(type: DashboardButton) {
        self.delegate?.tapped(button: type)
    }

}
