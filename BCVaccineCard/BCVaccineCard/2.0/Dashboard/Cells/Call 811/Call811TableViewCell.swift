//
//  Call811TableViewCell.swift
//  HealthGatewayTest
//
//  Created by Amir Shayegh on 2023-02-17.
//

import UIKit

class Call811TableViewCell: BaseDashboardTableViewCell {
    
    @IBOutlet private weak var call811TitleLabel: UILabel!
    @IBOutlet private weak var discoverMoreButton: UIButton!
    @IBOutlet private weak var discoverMoreArrowImage: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var healthNavButton: ButtonView!
    @IBOutlet private weak var registeredNurseButton: ButtonView!
    @IBOutlet private weak var pharmacistAdviceButton: ButtonView!
    @IBOutlet private weak var exerciseProfessionalButton: ButtonView!

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
        self.contentView.backgroundColor = UIColor(hexString: "#F2F2F2")
        let underlineAttr: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .bold),
            .foregroundColor: UIColor(hexString: "#1A5A96"),
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: UIColor(hexString: "#1A5A96")
        ]
        let attrString = NSMutableAttributedString(string: "Discover more ", attributes: underlineAttr)
        discoverMoreButton.setAttributedTitle(attrString, for: .normal)
//        discoverMoreButton.setImage(DashboardButton.discoverMore.getIcon, for: .normal)
//        discoverMoreButton.semanticContentAttribute = .forceRightToLeft
        discoverMoreButton.tintColor = UIColor(hexString: "#1A5A96")
        discoverMoreArrowImage.tintColor = UIColor(hexString: "#1A5A96")
        call811TitleLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        call811TitleLabel.textColor = UIColor(hexString: "#003366")
        call811TitleLabel.text = "Call 8-1-1"
        separatorView.backgroundColor = UIColor(hexString: "#E2A014")
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = UIColor(hexString: "#313132")
        descriptionLabel.text = "Speak to a health services navigator who can help you to find health information and services."
//        self.healthNavButton.configure(type: .healthNavigator, owner: self, rounding: 4)
//        self.registeredNurseButton.configure(type: .registeredNurse, owner: self, rounding: 4)
//        self.pharmacistAdviceButton.configure(type: .pharmasistAdvice, owner: self, rounding: 4)
//        self.exerciseProfessionalButton.configure(type: .exerciseProfessional, owner: self, rounding: 4)
    }
    
    @IBAction private func discoverMoreButtonAction(_ sender: UIButton) {
        self.delegate?.tapped(button: .discoverMore, connectType: .ignore)
    }
    
}

extension Call811TableViewCell: ButtonViewAction {
    func buttonTapped(type: DashboardButton, connectType: DashboardButton.ConnectType) {
        self.delegate?.tapped(button: type, connectType: connectType)
    }

}
