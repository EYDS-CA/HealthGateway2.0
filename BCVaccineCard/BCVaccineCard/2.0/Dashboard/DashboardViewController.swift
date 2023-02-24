//
//  DashboardViewController.swift
//  BCVaccineCard
//
//  Created by Amir Shayegh on 2023-02-17.
//

import UIKit

protocol DashboardTileDelegate {
    func tapped(button: DashboardButton, connectType: DashboardButton.ConnectType)
}

class DashboardViewController: UIViewController {
    
    class func construct(delegate: TabDelegate) -> DashboardViewController {
        if let vc = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(withIdentifier: String(describing: DashboardViewController.self)) as? DashboardViewController {
            vc.tabDelegate = delegate
            return vc
        }
        return DashboardViewController()
    }
    
    private var tabDelegate: TabDelegate?
    var navObserver: NSKeyValueObservation?
    
    var viewModel: DashboardViewModel = DashboardViewModel()
    
    var welcomeLabel: UILabel?
    var plusIcon: UIImageView?
    
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        self.title = "Health Gateway"
        setuTitleAccessories()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        setuTitleAccessories()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeTitleAccessories()
    }
    
    private func setuTitleAccessories() {
        setupTitleIcon()
        setupWelcomeLabel()
        navObserver?.invalidate()
        navObserver = navigationController?.navigationBar.observe(\.bounds, options: [.new], changeHandler: navChange)
    }
    
    private func removeTitleAccessories() {
        welcomeLabel?.removeFromSuperview()
        plusIcon?.removeFromSuperview()
        welcomeLabel = nil
        plusIcon = nil
    }
    
    private func setupWelcomeLabel() {
        welcomeLabel?.removeFromSuperview()
        welcomeLabel = nil
        guard let navBar = navigationController?.navigationBar else {return}
        let navControllerViewsWithLabels = navBar.subviews.compactMap({ $0.subviews.contains(where: { sub in
            return sub is UILabel
        }) ? $0 : nil })
        guard let labelView = navControllerViewsWithLabels.first?.subviews.filter({$0 is UILabel}).first else {
            return
        }
      
        let label = UILabel(frame: .zero)
        navBar.addSubview(label)
        label.text = "Welcome to your"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: labelView.leadingAnchor, constant: 0).isActive = true
        label.trailingAnchor.constraint(equalTo: labelView.trailingAnchor, constant: 0).isActive = true
        label.bottomAnchor.constraint(equalTo: labelView.topAnchor, constant: 0).isActive = true
        label.font = UIFont.bcSansBoldWithSize(size: 13)
        label.textColor = AppColours.appBlue
        welcomeLabel = label
    }
    
    private func setupTitleIcon() {
        plusIcon?.removeFromSuperview()
        plusIcon = nil
        guard let navBar = navigationController?.navigationBar else {return}
        let navControllerViewsWithLabels = navBar.subviews.compactMap({ $0.subviews.contains(where: { sub in
            return sub is UILabel
        }) ? $0 : nil })
        let iconSize: CGFloat = 17
        guard let labelView = navControllerViewsWithLabels.first?.subviews.filter({$0 is UILabel}).first else {
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
        plusIcon = imageView
    }
    
    func navChange(_ navigationBar: UINavigationBar,_ changes: NSKeyValueObservedChange<CGRect>) {
        if let height = changes.newValue?.height {
            if height >= 60.0 {
                setuTitleAccessories()
            } else {
                removeTitleAccessories()
            }
        }
    }
    
}
extension DashboardViewController: DashboardTileDelegate {
    func tapped(button: DashboardButton, connectType: DashboardButton.ConnectType) {
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
            switch connectType {
            case .phone:
                callNumber(phoneNumber: button.phoneNumber)
            case .email:
                return
            case .chat:
                guard let image = UIImage(named: "static-chat") else {
                    return
                }
                showStatic(image: image)
            case .videoCall:
                guard let image = UIImage(named: "static-call") else {
                    return
                }
                showStatic(image: image)
            case .ignore:
                return
            }
        case .connectHealthRecords:
            tabDelegate?.switchTo(tab: .UnAuthenticatedRecords)
        case .serviceFinder:
            tabDelegate?.switchTo(tab: .ServiceFinder)
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
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = DashboardSections(rawValue: section) else {return 0}
        switch section {
        case .ConnectWithHealthCareProviders:
            return viewModel.connectWithProvidersSectionCells.count
        case .LearnAboutYourHealth:
            return viewModel.learnAboutYourHealthSectionCells.count
        case .FindHealthServices:
            return viewModel.findHealthServicesSectionCells.count
        case .AccessHelthRecords:
            return viewModel.accessHelthRecordsCells.count
        }
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
        let row = viewModel.connectWithProvidersSectionCells[indexPath.row]
        
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
        let row = viewModel.learnAboutYourHealthSectionCells[indexPath.row]
       
        switch row {
        case .IllnessesAndSymptomChecker:
            let cell = illnessesAndSymptomCheckerCell(indexPath: indexPath)
            cell.setup()
            return cell
        }
    }
    
    func getFindHealthServices(cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = viewModel.findHealthServicesSectionCells[indexPath.row]
     
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
        let row = viewModel.accessHelthRecordsCells[indexPath.row]
        
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
