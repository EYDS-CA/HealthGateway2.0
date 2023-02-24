//
//  DashboardViewModel.swift
//  BCVaccineCard
//
//  Created by Amir Shayegh on 2023-02-24.
//

import Foundation

typealias ConnectWithProvidersSection = DashboardSections.ConnectWithHealthCareProvidersSection
typealias LearnAboutYourHealthSection = DashboardSections.LearnAboutYourHealthSection
typealias FindHealthServicesSection = DashboardSections.FindHealthServicesSection
typealias AccessHelthRecords = DashboardSections.AccessHelthRecordsSection

class DashboardViewModel {
    static let storeKey = "DashboardConfiguration"
    public var sections: [DashboardSections] = DashboardSections.allCases
    
    public var connectWithProvidersSectionCells: [ConnectWithProvidersSection] = ConnectWithProvidersSection.allCases
    public var learnAboutYourHealthSectionCells: [LearnAboutYourHealthSection] = LearnAboutYourHealthSection.allCases
    public var findHealthServicesSectionCells: [FindHealthServicesSection] = FindHealthServicesSection.allCases
    public var accessHelthRecordsCells: [AccessHelthRecords] = AccessHelthRecords.allCases
    
    public var config: DashboardConfig {
        didSet {
            saveConfig()
            loadConfig()
        }
    }
    
    init() {
        if let config = DashboardViewModel.fetchStoredConfig() {
            self.config = config
        } else {
            config = DashboardViewModel.defaultConfig()
        }
    }
    
    func loadConfig() {
        
        // first set based on hidden
        self.sections = config.sections.compactMap({ obj in
            if obj.value.hidden {
                return nil
            } else {
                return obj.key
        }})
        // sort
        // TODO:
        
        self.connectWithProvidersSectionCells = config.connectWithProvidersSectionCells.compactMap({ obj in
            if obj.value.hidden {
                return nil
            } else {
                return obj.key
        }})
        // sort
        // TODO:
        
        self.learnAboutYourHealthSectionCells = config.learnAboutYourHealthSectionCells.compactMap({ obj in
            if obj.value.hidden {
                return nil
            } else {
                return obj.key
        }})
        // sort
        // TODO:
        
        self.findHealthServicesSectionCells = config.findHealthServicesSectionCells.compactMap({ obj in
            if obj.value.hidden {
                return nil
            } else {
                return obj.key
        }})
        // sort
        // TODO:
        
        self.accessHelthRecordsCells = config.accessHelthRecordsCells.compactMap({ obj in
            if obj.value.hidden {
                return nil
            } else {
                return obj.key
        }})
        
        // sort
        // TODO:
    }
    
    func saveConfig() {
        let model = config
        let encoder = JSONEncoder()
        do {
            let encoded = try encoder.encode(model)
            UserDefaults.standard.set(encoded, forKey: DashboardViewModel.storeKey)
        } catch {
            return
        }
    }
    
    func adjust(section: DashboardSections, hidden: Bool, position: Int) {
        config.sections[section] = DashboardConfig.Config(index: position, hidden: hidden)
    }
    
    func adjust(cell: ConnectWithProvidersSection, hidden: Bool, position: Int) {
        config.connectWithProvidersSectionCells[cell] = DashboardConfig.Config(index: position, hidden: hidden)
    }
    
    func adjust(cell: LearnAboutYourHealthSection, hidden: Bool, position: Int) {
        config.learnAboutYourHealthSectionCells[cell] = DashboardConfig.Config(index: position, hidden: hidden)
    }
    
    func adjust(cell: FindHealthServicesSection, hidden: Bool, position: Int) {
        config.findHealthServicesSectionCells[cell] = DashboardConfig.Config(index: position, hidden: hidden)
    }
    
    func adjust(cell: AccessHelthRecords, hidden: Bool, position: Int) {
        config.accessHelthRecordsCells[cell] = DashboardConfig.Config(index: position, hidden: hidden)
    }
    
   
    
    static func fetchStoredConfig() -> DashboardConfig? {
        guard let savedData = UserDefaults.standard.object(forKey: DashboardViewModel.storeKey) as? Data else {
            return nil
        }
        let decoder = JSONDecoder()
        do {
            let savedConfig = try decoder.decode(DashboardConfig.self, from: savedData)
            return savedConfig
        } catch {
            return nil
        }
    }
    
    static func defaultConfig() -> DashboardConfig {
        var sections: [DashboardSections: DashboardConfig.Config] = [DashboardSections: DashboardConfig.Config]()
        DashboardSections.allCases.forEach { section in
            sections[section] = DashboardConfig.Config(index: section.rawValue, hidden: false)
        }
        
        var connectWithProvidersSectionCells: [ConnectWithProvidersSection: DashboardConfig.Config] = [ConnectWithProvidersSection: DashboardConfig.Config]()
        ConnectWithProvidersSection.allCases.forEach { cell in
            connectWithProvidersSectionCells[cell] = DashboardConfig.Config(index: cell.rawValue, hidden: false)
        }
        
        var learnAboutYourHealthSectionCells: [LearnAboutYourHealthSection: DashboardConfig.Config] = [LearnAboutYourHealthSection: DashboardConfig.Config]()
        LearnAboutYourHealthSection.allCases.forEach { cell in
            learnAboutYourHealthSectionCells[cell] = DashboardConfig.Config(index: cell.rawValue, hidden: false)
        }
        
        var findHealthServicesSectionCells: [FindHealthServicesSection: DashboardConfig.Config] = [FindHealthServicesSection: DashboardConfig.Config]()
        FindHealthServicesSection.allCases.forEach { cell in
            findHealthServicesSectionCells[cell] = DashboardConfig.Config(index: cell.rawValue, hidden: false)
        }
        
        var accessHelthRecordsCells: [AccessHelthRecords: DashboardConfig.Config] = [AccessHelthRecords: DashboardConfig.Config]()
        AccessHelthRecords.allCases.forEach { cell in
            accessHelthRecordsCells[cell] = DashboardConfig.Config(index: cell.rawValue, hidden: false)
        }
        
        return DashboardConfig(sections: sections,
                        connectWithProvidersSectionCells: connectWithProvidersSectionCells,
                        learnAboutYourHealthSectionCells: learnAboutYourHealthSectionCells,
                        findHealthServicesSectionCells: findHealthServicesSectionCells,
                        accessHelthRecordsCells: accessHelthRecordsCells)
        
    }
}


struct DashboardConfig: Codable {
    var sections: [DashboardSections: Config]
    var connectWithProvidersSectionCells: [ConnectWithProvidersSection: Config]
    var learnAboutYourHealthSectionCells: [LearnAboutYourHealthSection: Config]
    var findHealthServicesSectionCells: [FindHealthServicesSection: Config]
    var accessHelthRecordsCells: [AccessHelthRecords: Config]
    
    struct Config: Codable {
        var index: Int
        var hidden: Bool
    }
}
