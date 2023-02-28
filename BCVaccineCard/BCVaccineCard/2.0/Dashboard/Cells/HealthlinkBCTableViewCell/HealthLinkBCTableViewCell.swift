//
//  HealthLinkBCTableViewCell.swift
//  BCVaccineCard
//
//  Created by Connor Ogilvie on 2023-02-27.
//

import UIKit

class HealthLinkBCTableViewCell: BaseDashboardTableViewCell {
    
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var viaPhoneButton: ButtonView!
    @IBOutlet private weak var viaEmailButton: ButtonView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        self.backgroundColor = .clear
        backgroundImageView.image = UIImage(named: "healthlinkBG")
        backgroundImageView.layer.cornerRadius = 10.0
        backgroundImageView.clipsToBounds = true
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = UIColor(hexString: "#313132")
        titleLabel.text = "Healthlink BC"
        descriptionLabel.attributedText = attributedText(withString: "Speak to a health services navigator who can help you to find health information and services; or connect you directly with a registered nurse, a registered dietitian, a qualified exercise professional, or a pharmacist.", boldStrings: ["nurse", "dietitian", "exercise", "pharmacist"], font: UIFont.systemFont(ofSize: 15))
        viaPhoneButton.configure(type: .viaPhone, owner: self, padding: 16, weight: .medium)
        viaEmailButton.configure(type: .viaEmail, owner: self, padding: 16, weight: .medium)
    }
    
    func attributedText(withString string: String, boldStrings: [String], font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                     attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        var ranges: [NSRange] = []
        for boldString in boldStrings {
            let range = (string as NSString).range(of: boldString)
            ranges.append(range)
        }
        for range in ranges {
            attributedString.addAttributes(boldFontAttribute, range: range)
        }
        return attributedString
    }
    
}

extension HealthLinkBCTableViewCell: ButtonViewAction {
    func buttonTapped(type: DashboardButton, connectType: DashboardButton.ConnectType) {
        self.delegate?.tapped(button: type, connectType: connectType)
    }
}
