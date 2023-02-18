//
//  ButtonView.swift
//  BCVaccineCard
//
//  Created by Connor Ogilvie on 2023-02-17.
//

import UIKit

protocol ButtonViewAction: AnyObject {
    func buttonTapped(type: DashboardButton)
}

class ButtonView: UIView {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    private var type: DashboardButton?
    private weak var delegate: ButtonViewAction?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(ButtonView.getName, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        setup()
    }
    
    private func setup() {
        iconImageView.tintColor = AppColours.appBlue
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = AppColours.appBlue
        descriptionLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        descriptionLabel.textColor = AppColours.textBlack
        contentView.clipsToBounds = true
    }
    
    @IBAction private func buttonTapped(_ sender: UIButton) {
        guard let type = self.type else {
            print("ERROR NO DASH TYPE")
            return
        }
        self.delegate?.buttonTapped(type: type)
    }
    
    func configure(type: DashboardButton, owner: UITableViewCell, rounding: CGFloat) {
        self.contentView.layer.cornerRadius = rounding
        self.backgroundColor = .clear
        self.type = type
        self.iconImageView.image = type.getIcon
        self.titleLabel.text = type.getTitle
        self.descriptionLabel.text = type.getDescription
        self.delegate = owner as? ButtonViewAction
        if type == .call911 {
            self.contentView.backgroundColor = UIColor(hexString: "#E56578")
            self.iconImageView.tintColor = .white
            self.titleLabel.textColor = .white
            self.descriptionLabel.textColor = .white
        }
    }

    
}

extension DashboardButton {
    var getIcon: UIImage? {
        if #available(iOS 13.0, *) {
            switch self {
            case .findPhysitian:
                return UIImage(systemName: "arrow.right.circle.fill")
            case .call911:
                return UIImage(systemName: "phone.fill")
            case .virtualWalkIn:
                return UIImage(systemName: "figure.walk")
            case .chat:
                return UIImage(systemName: "ellipsis.message.fill")
//            case .illnessesAndCOnditions:
//                <#code#>
//            case .symptomChecker:
//                <#code#>
            case .healthNavigator:
                return UIImage(systemName: "phone.fill")
            case .registeredNurse:
                return UIImage(systemName: "phone.fill")
            case .pharmasistAdvice:
                return UIImage(systemName: "envelope.fill")
            case .exerciseProfessional:
                return UIImage(systemName: "envelope.fill")
            case .discoverMore:
                return UIImage(systemName: "arrow.up.right")
//            case .immunizeBC:
//                <#code#>
//            case .servicesNearYou:
//                <#code#>
//            case .suppotFoundy:
//                <#code#>
//            case .supportAllAges:
//                <#code#>
            default: return nil
            }
        } else {
            return nil
        }
    }
    
    var getTitle: String? {
        switch self {
        case .findPhysitian:
            return "Access A Family Physician, Nurse, Practitioner, And Other Health-Care Professionals"
        case .call911:
            return "Call 911"
        case .virtualWalkIn:
            return "Virtual Walk-In"
        case .chat:
            return "Chat"
//        case .illnessesAndCOnditions:
//            <#code#>
//        case .symptomChecker:
//            <#code#>
        case .healthNavigator:
            return "Health Navigator"
        case .registeredNurse:
            return "Registered Nurse"
        case .pharmasistAdvice:
            return "Pharmacist Advice"
        case .exerciseProfessional:
            return "Exercise Professional"
        case .discoverMore:
            return "Discover more"
//        case .immunizeBC:
//            <#code#>
//        case .servicesNearYou:
//            <#code#>
//        case .suppotFoundy:
//            <#code#>
//        case .supportAllAges:
//            <#code#>
        default: return nil
        }
    }
    
    var getDescription: String? {
        switch self {
        case .findPhysitian:
            return "It's quick and easy!"
        case .call911:
            return "Emergencies"
        case .virtualWalkIn:
            return "Virtual visit with a registered nurse"
        case .chat:
            return "Message a registered nurse"
//        case .illnessesAndCOnditions:
//            <#code#>
//        case .symptomChecker:
//            <#code#>
        case .healthNavigator:
            return "Call 8-1-1"
        case .registeredNurse:
            return "Call 8-1-1"
        case .pharmasistAdvice:
            return "Send email"
        case .exerciseProfessional:
            return "Send email"
        case .discoverMore:
            return nil
//        case .immunizeBC:
//            <#code#>
//        case .servicesNearYou:
//            <#code#>
//        case .suppotFoundy:
//            <#code#>
//        case .supportAllAges:
//            <#code#>
        default: return nil
        }
    }

}
