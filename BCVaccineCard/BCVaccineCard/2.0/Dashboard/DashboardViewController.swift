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
    case call911 = "911"
    case virtualWalkIn = "virtualWalkIn" // Static image
    case chat = "chat" // Static image
    case illnessesAndCOnditions = "https://www.healthlinkbc.ca/illnesses-conditions"
    case symptomChecker = "https://www.buoyhealth.com/symptom-checker/"
    case healthNavigator = "811"
    case registeredNurse = "0811"// TODO: remove one of the 2 811 buttons
    case pharmasistAdvice = "mailto:pharmasist@bc.ca"
    case exerciseProfessional = "mailto:exercise@bc.ca"
    case discoverMore = "discoverMore" // TOOO:
    case immunizeBC = "https://immunizebc.ca/"
    case servicesNearYou = "https://www.islandhealth.ca/"
    case suppotFoundy = "https://foundrybc.ca/"
    case supportAllAges = "https://www2.gov.bc.ca/gov/content/mental-health-support-in-bc"
}

enum DashboardCells: Int, CaseIterable {
    case findPhysitian
    case symptomChecker
    case call811
    case findServices
    case mentalHealth
}

class DashboardViewController: UIViewController {
    
    class func construct() -> DashboardViewController {
        if let vc = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(withIdentifier: String(describing: DashboardViewController.self)) as? DashboardViewController {
            return vc
        }
        return DashboardViewController()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
}
extension DashboardViewController: DashboardTileDelegate {
    func tapped(button: DashboardButton) {
        print(button)
        switch button {
        case .virtualWalkIn:
            // SHOW IMAGE
            break
        case .chat:
            // SHOW IMAGE
            break
        case .exerciseProfessional:
            sendMail(to: button.rawValue)
        case .pharmasistAdvice:
            sendMail(to: button.rawValue)
        case .call911:
            callNumber(phoneNumber: button.rawValue)
        case .healthNavigator:
            callNumber(phoneNumber: button.rawValue)
        case .registeredNurse:
            callNumber(phoneNumber: button.rawValue)
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
    }
    
    
    func getFindPhysitianCell(indexPath: IndexPath) -> FindPhysitianTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FindPhysitianTableViewCell.getName, for: indexPath) as? FindPhysitianTableViewCell else {
            return FindPhysitianTableViewCell()
        }
        cell.delegate = self
        return cell
    }
    
    func getSymptomCheckerCell(indexPath: IndexPath) -> SymptomCheckerTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SymptomCheckerTableViewCell.getName, for: indexPath) as? SymptomCheckerTableViewCell else {
            return SymptomCheckerTableViewCell()
        }
        cell.delegate = self
        return cell
    }
    
    func getCall811Cell(indexPath: IndexPath) -> Call811TableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Call811TableViewCell.getName, for: indexPath) as? Call811TableViewCell else {
            return Call811TableViewCell()
        }
        cell.delegate = self
        return cell
    }
    
    func getFindServicesCell(indexPath: IndexPath) -> FindServicesTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FindServicesTableViewCell.getName, for: indexPath) as? FindServicesTableViewCell else {
            return FindServicesTableViewCell()
        }
        cell.delegate = self
        return cell
    }
    
    func getMentalHealthCell(indexPath: IndexPath) -> MentalHealthTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MentalHealthTableViewCell.getName, for: indexPath) as? MentalHealthTableViewCell else {
            return MentalHealthTableViewCell()
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DashboardCells.allCases.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = DashboardCells(rawValue: indexPath.row) else {
            return UITableViewCell()
        }
        
        switch row {
            
        case .findPhysitian:
            let cell = getFindPhysitianCell(indexPath: indexPath)
            // TODO..
            return cell
        case .symptomChecker:
            let cell = getSymptomCheckerCell(indexPath: indexPath)
            cell.setup()
            return cell
        case .call811:
            let cell = getCall811Cell(indexPath: indexPath)
            // TODO..
            return cell
        case .findServices:
            let cell = getFindServicesCell(indexPath: indexPath)
            cell.setup()
            return cell
        case .mentalHealth:
            let cell = getMentalHealthCell(indexPath: indexPath)
            cell.setup()
            return cell
        }
    }
}
