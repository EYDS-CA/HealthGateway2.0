//
//  UsefulLinkTableViewCell.swift
//  BCVaccineCard
//
//  Created by Amir Shayegh on 2023-02-24.
//

import UIKit

class UsefulLinkTableViewCell: BaseDashboardTableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var button: DashboardButton?
    
    func setup(title: String, button: DashboardButton) {
        addGestures()
        style(title: title)
        self.button = button
    }
    
    func addGestures() {
        contentView.gestureRecognizers?.removeAll()
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
        contentView.isUserInteractionEnabled = true
        contentView.addGestureRecognizer(tap1)
    }
    
    @objc func onTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let button = button else {return}
        delegate?.tapped(button: button, connectType: .ignore)
    }
    
    func style(title: String) {
        let text = "• \(title)"
        let colour = UIColor(red: 0.102, green: 0.353, blue: 0.588, alpha: 1)
        label.textColor = colour
        icon.tintColor = colour
        label.font = UIFont.bcSansRegularWithSize(size: 15)
        let textRange = NSRange(location: 0, length: text.count)
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(.underlineStyle,
                                    value: NSUnderlineStyle.single.rawValue,
                                    range: textRange)
        // Add other attributes if needed
        label.attributedText = attributedText
    }
    
}
