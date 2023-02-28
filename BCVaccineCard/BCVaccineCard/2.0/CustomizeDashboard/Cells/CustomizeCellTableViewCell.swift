//
//  CustomizeCellTableViewCell.swift
//  BCVaccineCard
//
//  Created by Amir Shayegh on 2023-02-24.
//

import UIKit

class CustomizeCellTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    private var checked: Bool = false
    private var position: Int = 0
    
    var delegate: CustomizeCellDelegate?
    
    var connectWithProvidersSection: ConnectWithProvidersSection?
    var getHealthAdviceSection: GetHealthAdviceSection?
    var findHealthServicesSection: FindHealthServicesSection?
    var accessHelthRecords: AccessHelthRecords?
    var usefulLinks: UsefulLinks?
    
    func setup(cell: ConnectWithProvidersSection, enabled: Bool, position: Int) {
        self.position = position
        self.checked = enabled
        self.connectWithProvidersSection = cell
        style(isEnabled: enabled)
        label.text = cell.title()
    }
    
    func setup(cell: GetHealthAdviceSection, enabled: Bool, position: Int) {
        self.position = position
        self.checked = enabled
        self.getHealthAdviceSection = cell
        style(isEnabled: enabled)
        label.text = cell.title()
    }
    
    func setup(cell: FindHealthServicesSection, enabled: Bool, position: Int) {
        self.position = position
        self.checked = enabled
        self.findHealthServicesSection = cell
        style(isEnabled: enabled)
        label.text = cell.title()
    }
    
    func setup(cell: AccessHelthRecords, enabled: Bool, position: Int) {
        self.position = position
        self.checked = enabled
        self.accessHelthRecords = cell
        style(isEnabled: enabled)
        label.text = cell.title()
    }
    
    func setup(cell: UsefulLinks, enabled: Bool, position: Int) {
        self.position = position
        self.checked = enabled
        self.usefulLinks = cell
        style(isEnabled: enabled)
        label.text = cell.title()
    }
    
    func style(isEnabled: Bool) {
        checked = isEnabled
        addGestures()
        if isEnabled {
            imgView.image = UIImage(named: "checkbox-filled")
        } else {
            imgView.image = UIImage(named: "checkbox-empty")
        }
        label.font = UIFont.bcSansRegularWithSize(size: 15)
    }
    
    func addGestures() {
        imgView.gestureRecognizers?.removeAll()
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
        imgView.isUserInteractionEnabled = true
        imgView.addGestureRecognizer(tap1)
    }
    
    @objc func onTap(_ sender: UITapGestureRecognizer? = nil) {
        checked = !checked
        style(isEnabled: checked)
        changedTo(enabled: checked, position: position)
    }
    
    func changedTo(enabled: Bool, position: Int) {
        if let connectWithProvidersSection = self.connectWithProvidersSection {
            delegate?.adjust(cell: connectWithProvidersSection, hidden: !enabled, position: position)
        }
        if let getHealthAdviceSection = self.getHealthAdviceSection {
            delegate?.adjust(cell: getHealthAdviceSection, hidden: !enabled, position: position)
        }
        if let findHealthServicesSection = self.findHealthServicesSection {
            delegate?.adjust(cell: findHealthServicesSection, hidden: !enabled, position: position)
        }
        if let accessHelthRecords = self.accessHelthRecords {
            delegate?.adjust(cell: accessHelthRecords, hidden: !enabled, position: position)
        }
        if let usefulLinks = self.usefulLinks {
            delegate?.adjust(cell: usefulLinks, hidden: !enabled, position: position)
        }
    }
    
}

protocol CustomizeCellDelegate {
    func adjust(section: DashboardSections, hidden: Bool, position: Int)
    func adjust(cell: ConnectWithProvidersSection, hidden: Bool, position: Int)
    func adjust(cell: GetHealthAdviceSection, hidden: Bool, position: Int)
    func adjust(cell: FindHealthServicesSection, hidden: Bool, position: Int)
    func adjust(cell: AccessHelthRecords, hidden: Bool, position: Int)
    func adjust(cell: UsefulLinks, hidden: Bool, position: Int)
}
