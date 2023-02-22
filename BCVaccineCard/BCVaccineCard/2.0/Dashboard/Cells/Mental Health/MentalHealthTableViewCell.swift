//
//  MentalHealthTableViewCell.swift
//  HealthGatewayTest
//
//  Created by Amir Shayegh on 2023-02-17.
//

import UIKit

class MentalHealthTableViewCell: BaseDashboardTableViewCell {
    
    @IBOutlet weak var btnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var divider: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var allAgesContainer: UIView!
    @IBOutlet weak var foundryContainer: UIView!
    
    @IBOutlet weak var foundryTitle: UILabel!
    @IBOutlet weak var foundryDesc: UILabel!
    @IBOutlet weak var foundrybtn: UIButton!
    @IBOutlet weak var allAgesTitle: UILabel!
    @IBOutlet weak var allAgesDesc: UILabel!
    @IBOutlet weak var allAgesbtn: UIButton!
    
    func setup() {
        addGestures()
        style()
    }
    
    func addGestures() {
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.foundryTap(_:)))
        foundryContainer.isUserInteractionEnabled = true
        foundryContainer.addGestureRecognizer(tap1)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.allAgesTap(_:)))
        allAgesContainer.isUserInteractionEnabled = true
        allAgesContainer.addGestureRecognizer(tap2)
    }
    
    @objc func allAgesTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let delegate = delegate else {
            return
        }
        delegate.tapped(button: .supportAllAges)
    }
    @IBAction func allAgesBtnTap(_ sender: Any) {
        
        guard let delegate = delegate else {
            return
        }
        delegate.tapped(button: .supportAllAges)
    }
    
    @IBAction func foundryBtnTap(_ sender: Any) {
        
        guard let delegate = delegate  else {
            return
        }
        delegate.tapped(button: .suppotFoundy)
    }
    @objc func foundryTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let delegate = delegate  else {
            return
        }
        delegate.tapped(button: .suppotFoundy)
    }
    
    func style() {
        btnHeightConstraint.constant = 32
        divider.backgroundColor = AppColours.barYellow
        styleCell(title: titleLabel)
        styleCell(text: descLabel)
        descLabel.text = "Health services and resources and near you."
        titleLabel.text = "Mental Health & substance use support"
        
        bgView.backgroundColor = UIColor(red: 0.898, green: 0.941, blue: 1, alpha: 1)
        bgView.layer.cornerRadius = 12
        
        styleContainer(bgView: allAgesContainer,
                       titleLabel: allAgesTitle,
                       titleText: "All Ages",
                       button: allAgesbtn,
                       descLabel: allAgesDesc,
                       descText: "All mental health and substance use support.")
        
        styleContainer(bgView: foundryContainer,
                       titleLabel: foundryTitle,
                       titleText: "Foundry",
                       button: foundrybtn,
                       descLabel: foundryDesc,
                       descText: "Support for young people aged 12-24 years old.")
    }
    
    func styleContainer(bgView: UIView,
                        titleLabel: UILabel,
                        titleText: String,
                        button: UIButton,
                        descLabel: UILabel,
                        descText: String
    ) {
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 10
        titleLabel.font = UIFont.bcSansBoldWithSize(size: 13)
        titleLabel.textColor = AppColours.appBlue
        descLabel.font = UIFont.bcSansRegularWithSize(size: 13)
        descLabel.textColor = UIColor.black
        
        button.setTitle("", for: .normal)
        if #available(iOS 13.0, *) {
            let btnIcon = UIImage.init(systemName: "arrow.right.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16))?.withTintColor(AppColours.appBlue)
            button.setImage(btnIcon, for: .normal)
            button.tintColor = AppColours.appBlue
        }
        
        titleLabel.text = titleText
        descLabel.text = descText
    }
    
}
