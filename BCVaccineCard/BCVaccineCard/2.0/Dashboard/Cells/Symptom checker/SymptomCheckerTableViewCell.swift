//
//  SymptomCheckerTableViewCell.swift
//  HealthGatewayTest
//
//  Created by Amir Shayegh on 2023-02-17.
//

import UIKit

class SymptomCheckerTableViewCell: BaseDashboardTableViewCell {
    
    // MARK: Symptom Checker
    @IBOutlet weak var symptomCheckerBg: UIImageView!
    @IBOutlet weak var symptomCheckerTitleLabel: UILabel!
    @IBOutlet weak var symptomCheckerDesc: UILabel!
    @IBOutlet weak var symptomCheckerDivider: UIView!
    @IBOutlet weak var symptomCheckerView: UIView!
    // MARK: Conditions
    @IBOutlet weak var conditionsDivider: UIView!
    @IBOutlet weak var conditionsTitleLabel: UILabel!
    @IBOutlet weak var conditionsDesc: UILabel!
    @IBOutlet weak var conditionsBg: UIImageView!
    
    @IBOutlet weak var conditionsView: UIView!
    func setup() {
        addGestures()
        style()
    }
    
    func addGestures() {
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.symptomCheckerTap(_:)))
        symptomCheckerView.isUserInteractionEnabled = true
        symptomCheckerView.addGestureRecognizer(tap1)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.conditionsTap(_:)))
        conditionsView.isUserInteractionEnabled = true
        conditionsView.addGestureRecognizer(tap2)
    }
    
    @objc func symptomCheckerTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let delegate = delegate else {
            return
        }
        delegate.tapped(button: .symptomChecker)
    }
    
    @objc func conditionsTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let delegate = delegate  else {
            return
        }
        delegate.tapped(button: .illnessesAndCOnditions)
    }
    
    func style() {
        style(bgView: conditionsBg,
              image: UIImage(named: "conditionsIcon"),
              titleLabel: conditionsTitleLabel,
              titleString: "Illnesses & Conditions",
              divider: conditionsDivider,
              descLabel: conditionsDesc,
              descString: "Common health concerns")
        
        style(bgView: symptomCheckerBg,
              image: UIImage(named: "symptomCheckerIcon"),
              titleLabel: symptomCheckerTitleLabel,
              titleString: "Symptom Checker",
              divider: symptomCheckerDivider,
              descLabel: symptomCheckerDesc,
              descString: "Understand your medical symptoms")
        
        symptomCheckerView.layer.cornerRadius = 12
        conditionsView.layer.cornerRadius = 12
        
    }
    
    func style(bgView: UIImageView,
               image: UIImage?,
               titleLabel: UILabel,
               titleString: String,
               divider: UIView,
               descLabel: UILabel,
               descString: String
    ) {
        
        bgView.image = image
        bgView.clipsToBounds = true
        bgView.layer.cornerRadius = 16
        styleCell(text: descLabel)
        styleCell(title: titleLabel)
        titleLabel.text = titleString
        descLabel.text = descString
        divider.backgroundColor = AppColours.barYellow
        
        
    }
}
