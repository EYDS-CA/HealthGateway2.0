//
//  CustomizeDashboardViewController.swift
//  BCVaccineCard
//
//  Created by Amir Shayegh on 2023-02-24.
//

import UIKit

protocol CustomizeDashboardDelegate {
    func saveConfig(model: DashboardConfig)
}

class CustomizeDashboardViewController: UIViewController, Theme {
    
    class func construct(config: DashboardConfig, delegate: CustomizeDashboardDelegate) -> CustomizeDashboardViewController {
        if let vc = UIStoryboard(name: "CustomizeDashboard", bundle: nil).instantiateViewController(withIdentifier: String(describing: CustomizeDashboardViewController.self)) as? CustomizeDashboardViewController {
            vc.config = config
            vc.delegate = delegate
            return vc
        }
        return CustomizeDashboardViewController()
    }

    var config: DashboardConfig?
    var delegate: CustomizeDashboardDelegate?

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        guard let config = config else {return}
        delegate?.saveConfig(model: config)
        dismiss(animated: true)
    }
    
    func style() {
        titleLabel.textColor = AppColours.appBlue
        titleLabel.font = UIFont.bcSansBoldWithSize(size: 21)
        closeButton.tintColor = .black
        descLabel.textColor = UIColor(red: 0.376, green: 0.376, blue: 0.376, alpha: 1)
        descLabel.font = UIFont.bcSansRegularWithSize(size: 16)
        style(button: doneButton, style: .Fill, title: "Done", image: nil)
    }
    
    func adjust(section: DashboardSections, hidden: Bool, position: Int) {
        config?.sections[section] = DashboardConfig.Config(index: position, hidden: hidden)
    }
    
    func adjust(cell: ConnectWithProvidersSection, hidden: Bool, position: Int) {
        config?.connectWithProvidersSectionCells[cell] = DashboardConfig.Config(index: position, hidden: hidden)
    }
    
    func adjust(cell: GetHealthAdviceSection, hidden: Bool, position: Int) {
        config?.getHealthAdviceCells[cell] = DashboardConfig.Config(index: position, hidden: hidden)
    }
    
    func adjust(cell: FindHealthServicesSection, hidden: Bool, position: Int) {
        config?.findHealthServicesSectionCells[cell] = DashboardConfig.Config(index: position, hidden: hidden)
    }
    
    func adjust(cell: AccessHelthRecords, hidden: Bool, position: Int) {
        config?.accessHelthRecordsCells[cell] = DashboardConfig.Config(index: position, hidden: hidden)
    }
}
