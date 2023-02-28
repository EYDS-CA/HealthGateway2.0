//
//  CustomizeDashboardTableViewCell.swift
//  BCVaccineCard
//
//  Created by Amir Shayegh on 2023-02-24.
//

import UIKit

class CustomizeDashboardTableViewCell: BaseDashboardTableViewCell {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var robot: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var plusIcon: UIImageView!
    
    func setup() {
        style()
        addGestures()
    }
    
    func addGestures() {
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
        container.isUserInteractionEnabled = true
        container.addGestureRecognizer(tap1)
    }
    
    @objc func onTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let delegate = delegate else {
            return
        }
        delegate.tapped(button: .customizeDashboard, connectType: .ignore)
    }
    
    func style() {
        if #available(iOS 13.0, *) {
            let plusConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
            let plusImage = UIImage(systemName: "plus.circle", withConfiguration: plusConfig)
            plusIcon.image = plusImage
        }
        
        plusIcon.tintColor = .white
        titleLabel.textColor = .white
        descLabel.textColor = .white
        titleLabel.font = UIFont.bcSansBoldWithSize(size: 20)
        descLabel.font = UIFont.bcSansRegularWithSize(size: 15)
        container.backgroundColor = UIColor(red: 0.102, green: 0.353, blue: 0.588, alpha: 1)
        container.layer.cornerRadius = 10
    }
    
}
