//
//  HomeScreenViewController.swift
//  BCVaccineCard
//
//  Created by Connor Ogilvie on 2022-03-16.
//

import UIKit

class HomeScreenViewController: BaseViewController {
    
    enum DataSource {
        case banner(data: CommunicationBanner)
        case text(text: String)
        case button(type: HomeScreenCellType)
    }
    
    class func constructHomeScreenViewController() -> HomeScreenViewController {
        if let vc = Storyboard.home.instantiateViewController(withIdentifier: String(describing: HomeScreenViewController.self)) as? HomeScreenViewController {
            return vc
        }
        return HomeScreenViewController()
    }
    
    @IBOutlet weak private var tableView: UITableView!
    
    private var authManager: AuthManager = AuthManager()
    
    private let communicationSetvice: CommunicationSetvice = CommunicationSetvice(network: AFNetwork())
    private var communicationBanner: CommunicationBanner?
    private let connectionListener = NetworkConnection()
    
    private var dataSource: [DataSource] {
        genDataSource()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return UIStatusBarStyle.darkContent
        } else {
            return UIStatusBarStyle.default
        }
    }
    
    private func setup() {
        addObservablesForChangeInAuthenticationStatus()
        setupTableView()
        navSetup()
        
        connectionListener.initListener { [weak self] connected in
            guard let `self` = self else {return}
            if connected {
                self.fetchCommunicationBanner()
            }
        }
    }
    
    private func genDataSource() -> [DataSource] {
        var data: [DataSource] = [.text(text: "What do you want to focus on today?"), .button(type: .Records), .button(type: .Proofs), .button(type: .Resources)]
        if authManager.isAuthenticated && !StorageService.shared.fetchRecommendations().isEmpty {
            data.append(.button(type: .Recommendations))
        }
        if let banner = communicationBanner {
            data.insert(.banner(data: banner), at: 1)
        }
        return data
    }

    
}

// MARK: Navigation setup
extension HomeScreenViewController {
    fileprivate func navTitle(firstName: String? = nil) -> String {
        if authManager.isAuthenticated, let name = firstName ?? StorageService.shared.fetchAuthenticatedPatient()?.name?.firstName ?? authManager.firstName  {
            let sentenceCaseName = name.nameCase()
            return "Hi \(sentenceCaseName),"
        } else {
            return "Hello"
        }
    }
    
    private func navSetup(firstName: String? = nil) {
        var title: String = navTitle(firstName: firstName)
        self.navDelegate?.setNavigationBarWith(title: title,
                                               leftNavButton: nil,
                                               rightNavButton: NavButton(image: UIImage(named: "nav-settings"), action: #selector(self.settingsButton), accessibility: Accessibility(traits: .button, label: AccessibilityLabels.MyHealthPassesScreen.navRightIconTitle, hint: AccessibilityLabels.MyHealthPassesScreen.navRightIconHint)),
                                               navStyle: .large,
                                               navTitleSmallAlignment: .Center,
                                               targetVC: self,
                                               backButtonHintString: nil)
    }
}

// MARK: Observable logic for authentication status change
extension HomeScreenViewController {
    private func addObservablesForChangeInAuthenticationStatus() {
        NotificationCenter.default.addObserver(self, selector: #selector(authStatusChanged), name: .authStatusChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(patientAPIFetched), name: .patientAPIFetched, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(storageChangeEvent), name: .storageChangeEvent, object: nil)
        NotificationManager.listenToLoginDataClearedOnLoginRejection(observer: self, selector: #selector(reloadFromForcedLogout))
    }
        
    @objc private func storageChangeEvent(_ notification: Notification) {
        guard let event = notification.object as? StorageService.StorageEvent<Any> else {return}
        switch event.entity {
        case .Recommendation:
            tableView.reloadData()
        default:
            break
        }
    }
    
    @objc private func reloadFromForcedLogout(_ notification: Notification) {
        navSetup()
        self.tableView.reloadData()
    }
    
    // Note: Not using authenticated value right now, may just remove it. Leaving in for now in case some requirements change or if there are any edge cases not considered
    // FIXME: Either use the userInfo value or remove it - need to test more first (comment above)
    @objc private func authStatusChanged(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Bool] else { return }
        guard let authenticated = userInfo[Constants.AuthStatusKey.key] else { return }
        self.navSetup()
        self.tableView.reloadData()
    }
    
    @objc private func patientAPIFetched(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: String?] else { return }
        guard let firstName = userInfo["firstName"] else { return }
        self.navSetup(firstName: firstName)
        self.tableView.reloadData()
    }
}

// MARK: Table View Setup
extension HomeScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func setupTableView() {
        tableView.register(UINib.init(nibName: TextTableViewCell.getName, bundle: .main), forCellReuseIdentifier: TextTableViewCell.getName)
        tableView.register(UINib.init(nibName: HomeScreenTableViewCell.getName, bundle: .main), forCellReuseIdentifier: HomeScreenTableViewCell.getName)
        tableView.register(UINib.init(nibName: CommunicationBannerTableViewCell.getName, bundle: .main), forCellReuseIdentifier: CommunicationBannerTableViewCell.getName)
        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 231
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = dataSource[indexPath.row]
        switch data {
        case .text(text: let text):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.getName, for: indexPath) as? TextTableViewCell else { return UITableViewCell() }
            cell.configure(forType: .plainText, text: text, withFont: UIFont.bcSansBoldWithSize(size: 20), labelSpacingAdjustment: 30, textColor: AppColours.appBlue)
            return cell
        case .button(type: let type):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeScreenTableViewCell.getName, for: indexPath) as? HomeScreenTableViewCell else { return UITableViewCell() }
            cell.configure(forType: type, auth: authManager.isAuthenticated)
            return cell
        case .banner(data: let data):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommunicationBannerTableViewCell.getName, for: indexPath) as? CommunicationBannerTableViewCell else { return UITableViewCell() }
            cell.configure(data: communicationBanner, delegate: self)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = dataSource[indexPath.row]
        switch data {
        case .button(type: let type):
            goToTabForType(type: type)
        default: break
        }
    }
}

// MARK: Communications Banner
extension HomeScreenViewController: CommunicationBannerTableViewCellDelegate {
    func fetchCommunicationBanner() {
        communicationSetvice.fetchMessage {[weak self] result in
            guard let `self` = self else {
                return
            }
            
            if let message = result, message.shouldDisplay {
                self.communicationBanner = message
            } else {
                self.communicationBanner = nil
            }
           
            self.tableView.reloadData()
        }
    }
    
    func shouldUpdateUI() {
        tableView.performBatchUpdates(nil)
    }
    
    func onExpand(banner: CommunicationBanner?) {
        tableView.reloadData()
    }
    
    func onClose(banner: CommunicationBanner?) {
        tableView.performBatchUpdates(nil)
    }
    
    func onDismiss(banner: CommunicationBanner?) {
        guard let banner = banner else {
            return
        }

        communicationSetvice.dismiss(message: banner)
        communicationBanner = nil
        tableView.reloadData()
        fetchCommunicationBanner()
    }
    
    func onLearnMore(banner: CommunicationBanner?) {
        guard let banner = banner else {
            return
        }
        let learnMoreVC = CommunicationMessageUIViewController()
        learnMoreVC.banner = banner
        navigationController?.pushViewController(learnMoreVC, animated: true)
    }
    
}

// MARK: Navigation logic for each type here
extension HomeScreenViewController {
    private func goToTabForType(type: HomeScreenCellType) {
        guard let tabBarController = self.tabBarController as? TabBarController else { return }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        switch type {
        case .Records:
            if !authManager.isAuthenticated {
                handleGetStartedScenario(tabBarController: tabBarController)
            }
            tabBarController.selectedIndex = type.getTabIndex
        case .Proofs:
            tabBarController.selectedIndex = type.getTabIndex
        case .Resources:
            let vc = ResourceViewController.constructResourceViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .Recommendations:
            let vc = RecommendationsViewController.constructRecommendationsViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            vc.setup()
        }
    }
    
    private func handleGetStartedScenario(tabBarController: TabBarController) {
        self.showLogin(initialView: .Landing, sourceVC: .HomeScreen, presentingViewControllerReference: self) { authenticationStatus in
            guard authenticationStatus != .Cancelled else { return }
            let recordFlowDetails = RecordsFlowDetails(currentStack: self.getCurrentStacks.recordsStack)
//            let passesFlowDetails = PassesFlowDetails(currentStack: self.getCurrentStacks.passesStack)
            let scenario = AppUserActionScenarios.LoginSpecialRouting(values: ActionScenarioValues(currentTab: .records, recordFlowDetails: recordFlowDetails, passesFlowDetails: nil, loginSourceVC: .HomeScreen, authenticationStatus: authenticationStatus))
            self.routerWorker?.routingAction(scenario: scenario, goToTab: .records, delayInSeconds: 0.5)
        }
    }
}

