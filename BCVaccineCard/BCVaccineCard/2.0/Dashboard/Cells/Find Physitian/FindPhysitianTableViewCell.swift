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
    @IBOutlet private weak var call911Button: RowView!
    @IBOutlet private weak var virtualWalkInButton: RowView!
    @IBOutlet private weak var chatButton: RowView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setup() {
        roundedAccessViewButtonImageView.tintColor = .white
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.clipsToBounds = true
        self.contentView.backgroundColor = UIColor(hexString: "#E5F0FF")
        self.roundedAccessView.layer.cornerRadius = 10.0
        self.roundedAccessView.clipsToBounds = true
        self.roundedAccessView.backgroundColor = UIColor(hexString: "#003366")
        let attr: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .regular),
            .foregroundColor: UIColor.white
        ]
        roundedAccessViewTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        roundedAccessViewTitleLabel.textColor = .white
        let attrString = NSMutableAttributedString(string: DashboardButton.findPhysitian.getTitle ?? "", attributes: attr)
        let parStyle = NSMutableParagraphStyle()
        parStyle.lineSpacing = 1.5
        parStyle.lineHeightMultiple = 1.5
        attrString.addAttributes([NSAttributedString.Key.paragraphStyle: parStyle], range: NSMakeRange(0, attrString.length))
        roundedAccessViewTitleLabel.attributedText = attrString
        roundedseparatorView.backgroundColor = UIColor(hexString: "#E2A014")
        roundeddescriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        roundeddescriptionLabel.textColor = UIColor(hexString: "#CFCFCF")
        roundeddescriptionLabel.text = DashboardButton.findPhysitian.getDescription
        self.call911Button.configure(type: .call911, owner: self)
        self.virtualWalkInButton.configure(type: .virtualWalkIn, owner: self)
        self.chatButton.configure(type: .chat, owner: self)
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
