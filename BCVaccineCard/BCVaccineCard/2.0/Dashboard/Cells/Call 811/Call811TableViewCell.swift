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
        self.contentView.backgroundColor = AppColours.lightGray
        discoverMoreButton.setTitle("Discover more", for: .normal)
        discoverMoreButton.setTitleColor(AppColours.appBlue, for: .normal)
        call811TitleLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        call811TitleLabel.textColor = AppColours.appBlue
        call811TitleLabel.text = "Call 8-1-1"
        separatorView.backgroundColor = .systemYellow
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = AppColours.textGray
        descriptionLabel.text = "Speak to a health services navigator who can help you to find health information and services."
        self.healthNavButton.configure(type: .healthNavigator, owner: self, rounding: 4)
        self.registeredNurseButton.configure(type: .registeredNurse, owner: self, rounding: 4)
        self.pharmacistAdviceButton.configure(type: .pharmasistAdvice, owner: self, rounding: 4)
        self.exerciseProfessionalButton.configure(type: .exerciseProfessional, owner: self, rounding: 4)
    }
    
    @IBAction private func discoverMoreButtonAction(_ sender: UIButton) {
        self.delegate?.tapped(button: .discoverMore)
    }
    
}

extension Call811TableViewCell: ButtonViewAction {
    func buttonTapped(type: DashboardButton) {
        self.delegate?.tapped(button: type)
    }

}
