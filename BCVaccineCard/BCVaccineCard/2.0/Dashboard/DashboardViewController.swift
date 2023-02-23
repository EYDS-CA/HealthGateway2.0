//
//  DashboardViewController.swift
//  BCVaccineCard
//
//  Created by Amir Shayegh on 2023-02-17.
//

import UIKit

protocol DashboardTileDelegate {
    func tapped(button: DashboardButton)
}

enum DashboardButton: String, CaseIterable {
    case findPhysitian = "https://hcr.healthlinkbc.ca/"
    case call911 = "call911" // phoneNumber
    case virtualWalkIn = "virtualWalkIn" // Static image
    case chat = "chat" // Static image
    case illnessesAndCOnditions = "https://www.healthlinkbc.ca/illnesses-conditions"
    case symptomChecker = "https://www.buoyhealth.com/symptom-checker/"
    case healthNavigator = "healthNavigator" //phoneNumber
    case registeredNurse = "registeredNurse" //phoneNumber
    case pharmasistAdvice = "mailto:pharmasist@bc.ca" // EMAIL
    case exerciseProfessional = "mailto:exercise@bc.ca" // EMAIL
    case discoverMore = "discoverMore" // TOOO:
    case immunizeBC = "https://immunizebc.ca/"
    case appointmentReminders = "https://immunizebc.ca/reminders"
    case servicesNearYou = "https://www.islandhealth.ca/"
    case suppotFoundy = "https://foundrybc.ca/"
    case supportAllAges = "https://www2.gov.bc.ca/gov/content/mental-health-support-in-bc"
    case serviceFinder = "serviceFinder" // In app Action
    case connectHealthRecords = "connectHealthRecords" // In app action
    
    var phoneNumber: String {
        switch self {
        case .call911: return "911"
        case .healthNavigator: return "811"
        case .registeredNurse: return "811"
        default: return ""
        }
    }
}

enum DashboardSections: Int, CaseIterable {
    case ConnectWithHealthCareProviders
    case LearnAboutYourHealth
    case FindHealthServices
    case AccessHelthRecords
    
    func numberOfCells() -> Int {
        switch self {
        case .ConnectWithHealthCareProviders:
            return ConnectWithHealthCareProvidersSection.allCases.count
        case .LearnAboutYourHealth:
            return LearnAboutYourHealthSection.allCases.count
        case .FindHealthServices:
            return FindHealthServicesSection.allCases.count
        case .AccessHelthRecords:
            return AccessHelthRecordsSection.allCases.count
        }
    }
    
    func title() -> String {
        switch self {
        case .ConnectWithHealthCareProviders:
            return "Connect With Health Care Providers"
        case .LearnAboutYourHealth:
            return "Learn about your health & wellness"
        case .FindHealthServices:
            return "Find health services"
        case .AccessHelthRecords:
            return "Access your health records"
        }
    }
    
    enum ConnectWithHealthCareProvidersSection: Int, CaseIterable {
        case AccessHealthCareProfessionals
        case Contact
    }

    enum LearnAboutYourHealthSection: Int, CaseIterable {
        case IllnessesAndSymptomChecker
    }

    enum FindHealthServicesSection: Int, CaseIterable {
        case MentalHealthSupport
        case ImmunizeBCAndIslandHealth
        case serviceFinder
    }
    
    enum AccessHelthRecordsSection: Int, CaseIterable {
        case ConnectHealthGateway
    }

}

class DashboardViewController: UIViewController {
    
    class func construct() -> DashboardViewController {
        if let vc = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(withIdentifier: String(describing: DashboardViewController.self)) as? DashboardViewController {
            return vc
        }
        return DashboardViewController()
    }
    
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        self.title = "Health Gateway"
        setupTitleIcon()
    }
    
    func setupTitleIcon() {
        let navControllerViewsWithLabels = navigationController?.navigationBar.subviews.compactMap({ $0.subviews.contains(where: { sub in
            return sub is UILabel
        }) ? $0 : nil })
        let iconSize: CGFloat = 17
        guard let labelView = navControllerViewsWithLabels?.first?.subviews.filter({$0 is UILabel}).first else {
            return
        }
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: iconSize, height: iconSize))
        imageView.image = UIImage(named: "hg+")
        labelView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: labelView.trailingAnchor, constant: 0).isActive = true
        imageView.centerYAnchor.constraint(equalTo: labelView.centerYAnchor, constant: 0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: iconSize).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: iconSize).isActive = true
        
        // TODO: Add "welcome to your" label on top?
    }
    
}
extension DashboardViewController: DashboardTileDelegate {
    func tapped(button: DashboardButton) {
        print(button)
        switch button {
        case .virtualWalkIn:
            guard let image = UIImage(named: "static-call") else {
                return
            }
            showStatic(image: image)
        case .chat:
            guard let image = UIImage(named: "static-chat") else {
                return
            }
            showStatic(image: image)
        case .exerciseProfessional:
            sendMail(to: button.rawValue)
        case .pharmasistAdvice:
            sendMail(to: button.rawValue)
        case .call911:
            callNumber(phoneNumber: button.phoneNumber)
        case .healthNavigator:
            callNumber(phoneNumber: button.phoneNumber)
        case .registeredNurse:
            callNumber(phoneNumber: button.phoneNumber)
        case .connectHealthRecords:
            // TODO
            alert(title: "TODO", message: "TODO")
        case .serviceFinder:
            // TODO
            alert(title: "TODO", message: "TODO")
        default:
            showWeb(url: button.rawValue, withNavigation: true)
        }
    }
}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    private func setupTableView() {
        registerCells()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func registerCells() {
        tableView.register(UINib.init(nibName: FindPhysitianTableViewCell.getName, bundle: .main), forCellReuseIdentifier: FindPhysitianTableViewCell.getName)
        tableView.register(UINib.init(nibName: SymptomCheckerTableViewCell.getName, bundle: .main), forCellReuseIdentifier: SymptomCheckerTableViewCell.getName)
        tableView.register(UINib.init(nibName: Call811TableViewCell.getName, bundle: .main), forCellReuseIdentifier: Call811TableViewCell.getName)
        tableView.register(UINib.init(nibName: FindServicesTableViewCell.getName, bundle: .main), forCellReuseIdentifier: FindServicesTableViewCell.getName)
        tableView.register(UINib.init(nibName: MentalHealthTableViewCell.getName, bundle: .main), forCellReuseIdentifier: MentalHealthTableViewCell.getName)
        tableView.register(UINib.init(nibName: ServiceFinderDashboardTableViewCell.getName, bundle: .main), forCellReuseIdentifier: ServiceFinderDashboardTableViewCell.getName)
        tableView.register(UINib.init(nibName: ConnectHealthGatewayDashboardTableViewCell.getName, bundle: .main), forCellReuseIdentifier: ConnectHealthGatewayDashboardTableViewCell.getName)
        tableView.register(UINib.init(nibName: ContactDashboardTableViewCell.getName, bundle: .main), forCellReuseIdentifier: ContactDashboardTableViewCell.getName)
    }
    
    func accessHealthCareProfessionalsCell(indexPath: IndexPath) -> FindPhysitianTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FindPhysitianTableViewCell.getName, for: indexPath) as? FindPhysitianTableViewCell else {
            return FindPhysitianTableViewCell()
        }
        cell.delegate = self
        return cell
    }
    
    func illnessesAndSymptomCheckerCell(indexPath: IndexPath) -> SymptomCheckerTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SymptomCheckerTableViewCell.getName, for: indexPath) as? SymptomCheckerTableViewCell else {
            return SymptomCheckerTableViewCell()
        }
        cell.delegate = self
        return cell
    }
    func ContactCell(indexPath: IndexPath) -> ContactDashboardTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactDashboardTableViewCell.getName, for: indexPath) as? ContactDashboardTableViewCell else {
            return ContactDashboardTableViewCell()
        }
        cell.delegate = self
        return cell
    }
    
    func immunizeBCAndIslandHealthCell(indexPath: IndexPath) -> FindServicesTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FindServicesTableViewCell.getName, for: indexPath) as? FindServicesTableViewCell else {
            return FindServicesTableViewCell()
        }
        cell.delegate = self
        return cell
    }
    
    func mentalHealthSupportCell(indexPath: IndexPath) -> MentalHealthTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MentalHealthTableViewCell.getName, for: indexPath) as? MentalHealthTableViewCell else {
            return MentalHealthTableViewCell()
        }
        cell.delegate = self
        return cell
    }
    
    func serviceFinderCell(indexPath: IndexPath) -> ServiceFinderDashboardTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ServiceFinderDashboardTableViewCell.getName, for: indexPath) as? ServiceFinderDashboardTableViewCell else {
            return ServiceFinderDashboardTableViewCell()
        }
        cell.delegate = self
        return cell
    }
    
    func connectHealthGatewayCell(indexPath: IndexPath) -> ConnectHealthGatewayDashboardTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConnectHealthGatewayDashboardTableViewCell.getName, for: indexPath) as? ConnectHealthGatewayDashboardTableViewCell else {
            return ConnectHealthGatewayDashboardTableViewCell()
        }
        cell.delegate = self
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return DashboardSections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = DashboardSections(rawValue: section) else {return 0}
        return section.numberOfCells()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = DashboardSections(rawValue: indexPath.section) else {return UITableViewCell()}
        
        switch section {
        case .ConnectWithHealthCareProviders:
            return getConnectWithHealthCareProviders(cellForRowAt: indexPath)
        case .LearnAboutYourHealth:
            return getLearnAboutYourHealth(cellForRowAt: indexPath)
        case .FindHealthServices:
            return getFindHealthServices(cellForRowAt: indexPath)
        case .AccessHelthRecords:
            return getAccessHelthRecords(cellForRowAt: indexPath)
        }
    }

    func getConnectWithHealthCareProviders(cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = DashboardSections.ConnectWithHealthCareProvidersSection(rawValue: indexPath.row) else {
            return UITableViewCell()
        }
        
        switch row {
        case .AccessHealthCareProfessionals:
            let cell = accessHealthCareProfessionalsCell(indexPath: indexPath)
            return cell
        case .Contact:
            let cell = ContactCell(indexPath: indexPath)
            return cell
        }
    }
    
    func getLearnAboutYourHealth(cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = DashboardSections.LearnAboutYourHealthSection(rawValue: indexPath.row) else {
            return UITableViewCell()
        }
        switch row {
        case .IllnessesAndSymptomChecker:
            let cell = illnessesAndSymptomCheckerCell(indexPath: indexPath)
            cell.setup()
            return cell
        }
    }
    
    func getFindHealthServices(cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = DashboardSections.FindHealthServicesSection(rawValue: indexPath.row) else {
            return UITableViewCell()
        }
        switch row {
        case .MentalHealthSupport:
            let cell = mentalHealthSupportCell(indexPath: indexPath)
            cell.setup()
            return cell
        case .ImmunizeBCAndIslandHealth:
            let cell = immunizeBCAndIslandHealthCell(indexPath: indexPath)
            cell.setup()
            return cell
        case .serviceFinder:
            let cell = serviceFinderCell(indexPath: indexPath)
            cell.setup()
            return cell
        }
    }
    
    func getAccessHelthRecords(cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = DashboardSections.AccessHelthRecordsSection(rawValue: indexPath.row) else {
            return UITableViewCell()
        }
        switch row {
        case .ConnectHealthGateway:
            let cell = connectHealthGatewayCell(indexPath: indexPath)
            cell.setup()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = DashboardSections(rawValue: section) else {return nil}
        let container = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 42))
        let label = UILabel(frame: container.bounds)
        container.addSubview(label)
        label.addEqualSizeContraints(to: container)
        label.text = section.title()
        label.font = UIFont.bcSansBoldWithSize(size: 15)
        label.heightAnchor.constraint(equalToConstant: 42).isActive = true
        container.backgroundColor = .white
        return container
    }
}
