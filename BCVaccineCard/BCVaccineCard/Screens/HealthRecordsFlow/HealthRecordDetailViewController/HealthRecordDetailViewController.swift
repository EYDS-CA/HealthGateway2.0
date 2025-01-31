//
//  HealthRecordDetailViewController.swift
//  BCVaccineCard
//
//  Created by Connor Ogilvie on 2021-11-29.
// TODO: This view controller will be a table view with "Delete" in the navigation bar, and will be customizable depending on what the record is, etc. Will likely use an enum here for imm record, or test result

import UIKit

class HealthRecordDetailViewController: BaseViewController, HealthRecordDetailDelegate {
    class func constructHealthRecordDetailViewController(dataSource: HealthRecordsDetailDataSource, authenticatedRecord: Bool, userNumberHealthRecords: Int, patient: Patient?) -> HealthRecordDetailViewController {
        if let vc = Storyboard.records.instantiateViewController(withIdentifier: String(describing: HealthRecordDetailViewController.self)) as? HealthRecordDetailViewController {
            vc.dataSource = dataSource
            vc.authenticatedRecord = authenticatedRecord
            vc.userNumberHealthRecords = userNumberHealthRecords
            vc.patient = patient
            return vc
        }
        return HealthRecordDetailViewController()
    }
    
    @IBOutlet weak private var tableView: UITableView!
    
    public static var currentInstance: HealthRecordDetailViewController!
    
    private var dataSource: HealthRecordsDetailDataSource!
    private var authenticatedRecord: Bool!
    private var userNumberHealthRecords: Int!
    private var patient: Patient?
    private var pdfData: String?
    private var reportId: String?
    private var type: LabTestType?
    private var pdfAPIWorker: PDFAPIWorker?
    
    let connectionListener = NetworkConnection()
    
    override var getRecordFlowType: RecordsFlowVCs? {
        return .HealthRecordDetailViewController(patient: self.patient, dataSource: self.dataSource, userNumberHealthRecords: userNumberHealthRecords)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HealthRecordDetailViewController.currentInstance = self
        navSetup(hasConnection: NetworkConnection.shared.hasConnection)
        setupStorageListener()
        connectionListener.initListener { [weak self] connected in
            guard let `self` = self else {return}
            self.navSetup(hasConnection: connected)
        }
    }
    
    // TODO: We should look into this - not sure we should pop to root VC from detail view on a storage change
    func setupStorageListener() {
        Notification.Name.storageChangeEvent.onPost(object: nil, queue: .main) { [weak self] notification in
            guard let `self` = self else {return}
            if let event = notification.object as? StorageService.StorageEvent<Any> {
                switch event.entity {
                case .VaccineCard :
                    if let object = event.object as? VaccineCard, object.patient?.name == self.dataSource.name {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    // Note: Check this - this appears to be where the issue is - will have to check lines below, as this appears to be what's causing the issue
                case .CovidLabTestResult:
                    if let object = event.object as? CovidLabTestResult, object.patient?.name == self.dataSource.name {
                        guard event.event != .ManuallyAddedPendingTestBackgroundRefetch else { return }
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                case .Medication:
                    if let object = event.object as? Perscription, object.patient?.name == self.dataSource.name {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                case .LaboratoryOrder:
                    if let object = event.object as? LaboratoryOrder, object.patient?.name == self.dataSource.name {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                default:
                    break
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNeedsStatusBarAppearanceUpdate()
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupContent()
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.pdfAPIWorker = nil
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return UIStatusBarStyle.darkContent
        } else {
            return UIStatusBarStyle.default
        }
    }
    
    func setupContent() {
        let recordsView: HealthRecordsView = HealthRecordsView()
        recordsView.frame = .zero
        recordsView.bounds = view.bounds
        view.addSubview(recordsView)
        recordsView.layoutIfNeeded()
        recordsView.addEqualSizeContraints(to: self.view, safe: true)
        // Note: keep this here so the child views in HealthRecordsView get sized properly
        view.layoutSubviews()
        recordsView.configure(models: dataSource.records, delegate: self)
        view.layoutSubviews()
    }
    
    func showComments(for record: HealthRecordsDetailDataSource.Record) {
        let vc = CommentsViewController.constructCommentsViewController(model: record)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: Navigation setup
extension HealthRecordDetailViewController {
    private func navSetup(hasConnection: Bool) {
        let navDownloadIcon = hasConnection ? UIImage(named: "nav-download") : UIImage(named: "nav-download-disabled")?.withRenderingMode(.alwaysOriginal)

        var rightNavButton: NavButton?
        switch dataSource.type {
        case .laboratoryOrder(model: let labOrder):
            if labOrder.reportAvailable == true {
                self.type = .normal
//                rightNavButton = NavButton(image: navDownloadIcon, action: #selector(self.showPDFView), accessibility: Accessibility(traits: .button, label: AccessibilityLabels.HealthRecordsDetailScreen.navRightIconTitlePDF, hint: AccessibilityLabels.HealthRecordsDetailScreen.navRightIconHintPDF))
            }
        case .covidTestResultRecord(model: let covidTestOrder):
            if covidTestOrder.reportAvailable == true {
                self.type = .covid
//                rightNavButton = NavButton(image: navDownloadIcon, action: #selector(self.showPDFView), accessibility: Accessibility(traits: .button, label: AccessibilityLabels.HealthRecordsDetailScreen.navRightIconTitlePDF, hint: AccessibilityLabels.HealthRecordsDetailScreen.navRightIconHintPDF))
            }
        default:
            // NOTE: Enable Delete Record
//            rightNavButton = self.authenticatedRecord ? nil :
//            NavButton(
//                title: .delete,
//                image: nil, action: #selector(self.deleteButton),
//                accessibility: Accessibility(traits: .button, label: AccessibilityLabels.HealthRecordsDetailScreen.navRightIconTitle, hint: AccessibilityLabels.HealthRecordsDetailScreen.navRightIconHint))
            rightNavButton = nil
        }
        
        self.navDelegate?.setNavigationBarWith(title: dataSource.title,
                                               leftNavButton: nil,
                                               rightNavButton: rightNavButton,
                                               navStyle: .small,
                                               navTitleSmallAlignment: .Center,
                                               targetVC: self,
                                               backButtonHintString: nil)
    }
    
    @objc private func deleteButton(manuallyAdded: Bool) {
        alertConfirmation(title: dataSource.deleteAlertTitle, message: dataSource.deleteAlertMessage, confirmTitle: .delete, confirmStyle: .destructive) {
            [weak self] in
            guard let `self` = self else {return}
            switch self.dataSource.type {
            case .covidImmunizationRecord(model: let model, immunizations: _):
                StorageService.shared.deleteVaccineCard(vaccineQR: model.code, manuallyAdded: manuallyAdded)
                DispatchQueue.main.async {

                    let recordFlowDetails = RecordsFlowDetails(currentStack: self.getCurrentStacks.recordsStack)
//                    let passesFlowDetails = PassesFlowDetails(currentStack: self.getCurrentStacks.passesStack)
                    let values = ActionScenarioValues(currentTab: self.getCurrentTab, affectedTabs: [], recordFlowDetails: recordFlowDetails, passesFlowDetails: nil)
                    self.routerWorker?.routingAction(scenario: .ManuallyDeletedAllOfAnUnauthPatientRecords(values: values))
                }
            case .covidTestResultRecord:
                guard let recordId = self.dataSource.id else {return}
                StorageService.shared.deleteCovidTestResult(id: recordId, sendDeleteEvent: true)
            case .medication, .laboratoryOrder:
                Logger.log(string: "Not able to delete these records currently, as they are auth-only records", type: .general)
            case .immunization(model: let model):
                Logger.log(string: "Not able to delete these records currently, as they are auth-only records", type: .general)
            case .healthVisit(model: let model):
                Logger.log(string: "Not able to delete these records currently, as they are auth-only records", type: .general)
            case .specialAuthorityDrug(model: let model):
                Logger.log(string: "Not able to delete these records currently, as they are auth-only records", type: .general)
            case .hospitalVisit(model: let model):
                Logger.log(string: "Not able to delete these records currently, as they are auth-only records", type: .general)
            case .clinicalDocument(model: let model):
                Logger.log(string: "Not able to delete these records currently, as they are auth-only records", type: .general)
            }
            if self.userNumberHealthRecords > 1 {
                self.navigationController?.popViewController(animated: true)
            } else {
                if let name = self.patient?.name, let birthday = self.patient?.birthday, self.patient?.authenticated == false {
                    StorageService.shared.deletePatient(name: name, birthday: birthday)
                }
                DispatchQueue.main.async {
                    let recordFlowDetails = RecordsFlowDetails(currentStack: self.getCurrentStacks.recordsStack)
//                    let passesFlowDetails = PassesFlowDetails(currentStack: self.getCurrentStacks.passesStack)
                    let values = ActionScenarioValues(currentTab: self.getCurrentTab, affectedTabs: [.records], recordFlowDetails: recordFlowDetails, passesFlowDetails: nil)
                    self.routerWorker?.routingAction(scenario: .ManuallyDeletedAllOfAnUnauthPatientRecords(values: values))
                }
            }
        } onCancel: {
        }
    }
    
    private func showPDFUnavailableAlert() {
        self.alert(title: "Error", message: "There was an error fetching the PDF of this record")
    }
}

extension HealthRecordDetailViewController: AppStyleButtonDelegate {
    func buttonTapped(type: AppStyleButton.ButtonType) {
        switch type {
        case .viewPDF, .downloadFullReport:
            showPDF()
        default:
            break
        }
    }
    
    func showPDF() {
        // Cached
        if let pdf = self.pdfData {
            self.showPDFDocument(pdfString: pdf, navTitle: dataSource.title, documentVCDelegate: self, navDelegate: self.navDelegate)
            return
        }
        // No internet
        if !NetworkConnection.shared.hasConnection {
            AppDelegate.sharedInstance?.showToast(message: "No internet connection", style: .Warn)
            return
        }
        // Fetch
        guard let patient = self.patient else {return}
        PDFService(network: AFNetwork(), authManager: AuthManager()).fetchPDF(record: dataSource, patient: patient, completion: { [weak self] result in
            guard let `self` = self else {return}
            if let pdf = result {
                self.pdfData = pdf
                self.showPDFDocument(pdfString: pdf, navTitle: self.dataSource.title, documentVCDelegate: self, navDelegate: self.navDelegate)
            } else {
                self.showPDFUnavailableAlert()
            }
        })
    }
}

// MARK: This is for showing the PDF view using native behaviour
extension HealthRecordDetailViewController: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        guard let navController = self.navigationController else { return self }
        return navController
    }
}
