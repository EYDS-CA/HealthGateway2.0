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
        setupTableView()
        style()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
   
}

extension CustomizeDashboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func setupTableView() {
        registerCells()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func registerCells() {
        tableView.register(UINib.init(nibName: CustomizeCellTableViewCell.getName, bundle: .main), forCellReuseIdentifier: CustomizeCellTableViewCell.getName)
    }
    
    func rowCell(indexPath: IndexPath) -> CustomizeCellTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomizeCellTableViewCell.getName, for: indexPath) as? CustomizeCellTableViewCell else {
            return CustomizeCellTableViewCell()
        }
        cell.delegate = self
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        DashboardSections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = DashboardSections(rawValue: section) else {return 0}
        return section.numberOfCells()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = DashboardSections(rawValue: indexPath.section) else {return UITableViewCell()}
        let cell = rowCell(indexPath: indexPath)
        
        switch section {
        case .ConnectWithHealthCareProviders:
            guard let item = DashboardSections.ConnectWithHealthCareProvidersSection(rawValue: indexPath.row) else {
                return UITableViewCell()
            }
            let configForItem = config?.connectWithProvidersSectionCells[item]
            cell.setup(cell: item, enabled: !(configForItem?.hidden ?? false), position: configForItem?.index ?? 0)
        case .GetHealthAdvice:
            guard let item = DashboardSections.GetHealthAdviceSection(rawValue: indexPath.row) else {
                return UITableViewCell()
            }
            let configForItem = config?.getHealthAdviceCells[item]
            cell.setup(cell: item, enabled: !(configForItem?.hidden ?? false), position: configForItem?.index ?? 0)
        case .FindHealthServices:
            guard let item = DashboardSections.FindHealthServicesSection(rawValue: indexPath.row) else {
                return UITableViewCell()
            }
            let configForItem = config?.findHealthServicesSectionCells[item]
            cell.setup(cell: item, enabled: !(configForItem?.hidden ?? false), position: configForItem?.index ?? 0)
        case .AccessHelthRecords:
            guard let item = DashboardSections.AccessHelthRecordsSection(rawValue: indexPath.row) else {
                return UITableViewCell()
            }
            let configForItem = config?.accessHelthRecordsCells[item]
            cell.setup(cell: item, enabled: !(configForItem?.hidden ?? false), position: configForItem?.index ?? 0)
        case .UsefulLinks:
            guard let item = DashboardSections.UsefulLinksSection(rawValue: indexPath.row) else {
                return UITableViewCell()
            }
            let configForItem = config?.usefulLinksCells[item]
            cell.setup(cell: item, enabled: !(configForItem?.hidden ?? false), position: configForItem?.index ?? 0)
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = DashboardSections(rawValue: section) else {return nil}
        guard !section.title().isEmpty else {return UIView(frame: .zero)}
        
        let container = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 21))
        container.backgroundColor = .white
        let label = UILabel(frame: container.bounds)
        container.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0).isActive = true
        label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0).isActive = true
        label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 0).isActive = true
        
        label.text = section.title()
        label.font = UIFont.bcSansBoldWithSize(size: 15)
        label.heightAnchor.constraint(equalToConstant: 42).isActive = true
        let checkBox = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        container.addSubview(checkBox)
        
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        checkBox.centerYAnchor.constraint(equalTo: label.centerYAnchor, constant: 0).isActive = true
        checkBox.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16).isActive = true
        checkBox.widthAnchor.constraint(equalToConstant: 30).isActive = true
        checkBox.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let configForItem = config?.sections[section]
        let isOn = !(configForItem?.hidden ?? false)
        
        if isOn {
            checkBox.image = UIImage(named: "checkbox-filled")
        } else {
            checkBox.image = UIImage(named: "checkbox-empty")
        }

        let divider = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
        container.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.topAnchor.constraint(equalTo: container.topAnchor, constant: 0).isActive = true
        divider.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -16).isActive = true
        divider.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0).isActive = true
        divider.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 2).isActive = true
        divider.backgroundColor = UIColor(red: 0.871, green: 0.871, blue: 0.871, alpha: 1)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
        checkBox.isUserInteractionEnabled = true
        checkBox.addGestureRecognizer(tap1)
        checkBox.tag = section.rawValue
        return container
    }
    
    @objc func onTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let view = sender?.view as? UIImageView else { return }
        guard let section = DashboardSections(rawValue: view.tag) else {return}
        let configForItem = config?.sections[section]
        var isOn = !(configForItem?.hidden ?? true)
        isOn = !isOn
        self.adjust(section: section, hidden: !isOn, position: configForItem?.index ?? 0)
        
        if isOn {
            view.image = UIImage(named: "checkbox-filled")
        } else {
            view.image = UIImage(named: "checkbox-empty")
        }
    }
}

extension CustomizeDashboardViewController: CustomizeCellDelegate {
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
    
    func adjust(cell: UsefulLinks, hidden: Bool, position: Int) {
        config?.usefulLinksCells[cell] = DashboardConfig.Config(index: position, hidden: hidden)
    }
}


final class BindableGestureRecognizer: UITapGestureRecognizer {
    private var action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
        super.init(target: nil, action: nil)
        self.addTarget(self, action: #selector(execute))
    }

    @objc private func execute() {
        action()
    }
}
