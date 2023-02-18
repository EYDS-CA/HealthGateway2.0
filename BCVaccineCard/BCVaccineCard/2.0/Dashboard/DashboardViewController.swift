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

enum DashboardButton: CaseIterable {
    case findPhysitian
    case call911
    case virtualWalkIn
    case chat
    case illnessesAndCOnditions
    case symptomChecker
    case healthNavigator
    case registeredNurse
    case pharmasistAdvice
    case exerciseProfessional
    case discoverMore
    case immunizeBC
    case servicesNearYou
    case suppotFoundy
    case supportAllAges
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
        case .findPhysitian:
            break
        case .call911:
            break
        case .virtualWalkIn:
            break
        case .chat:
            break
        case .illnessesAndCOnditions:
            break
        case .symptomChecker:
            break
        case .healthNavigator:
            break
        case .registeredNurse:
            break
        case .pharmasistAdvice:
            break
        case .exerciseProfessional:
            break
        case .discoverMore:
            break
        case .immunizeBC:
            break
        case .servicesNearYou:
            break
        case .suppotFoundy:
            break
        case .supportAllAges:
            break
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
