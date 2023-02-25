//
//  DashboardViewModel.swift
//  BCVaccineCard
//
//  Created by Amir Shayegh on 2023-02-24.
//

import Foundation

typealias ConnectWithProvidersSection = DashboardSections.ConnectWithHealthCareProvidersSection
typealias GetHealthAdviceSection = DashboardSections.GetHealthAdviceSection
typealias FindHealthServicesSection = DashboardSections.FindHealthServicesSection
typealias AccessHelthRecords = DashboardSections.AccessHelthRecordsSection
typealias UsefulLinks = DashboardSections.UsefulLinksSection

class DashboardViewModel {
    static let storeKey = "DashboardConfiguration"
    public var sections: [DashboardSections] = DashboardSections.allCases
    
    public var connectWithProvidersSectionCells: [ConnectWithProvidersSection] = ConnectWithProvidersSection.allCases
    public var GetHealthAdviceCells: [GetHealthAdviceSection] = GetHealthAdviceSection.allCases
    public var findHealthServicesSectionCells: [FindHealthServicesSection] = FindHealthServicesSection.allCases
    public var accessHelthRecordsCells: [AccessHelthRecords] = AccessHelthRecords.allCases
    public var usefulLinksCells: [UsefulLinks] = UsefulLinks.allCases
    
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
        loadConfig()
    }
    
    func loadConfig() {
        
        // first set based on hidden
        self.sections = config.sections.compactMap({ obj in
            if obj.value.hidden {
                return nil
            } else {
                return obj.key
        }})
        // TODO: Sort
        self.sections = sections.sorted(by: { left, right in
            return left.rawValue < right.rawValue
        })
        
        self.connectWithProvidersSectionCells = config.connectWithProvidersSectionCells.compactMap({ obj in
            if obj.value.hidden {
                return nil
            } else {
                return obj.key
        }})
        // TODO: Sort
        self.connectWithProvidersSectionCells = connectWithProvidersSectionCells.sorted(by: { left, right in
            return left.rawValue < right.rawValue
        })
        
        if self.connectWithProvidersSectionCells.isEmpty {
            sections.removeAll(where: {$0 == .ConnectWithHealthCareProviders})
        }
        
        self.GetHealthAdviceCells = config.getHealthAdviceCells.compactMap({ obj in
            if obj.value.hidden {
                return nil
            } else {
                return obj.key
        }})
        // TODO: Sort
        self.GetHealthAdviceCells = GetHealthAdviceCells.sorted(by: { left, right in
            return left.rawValue < right.rawValue
        })
        
        if self.GetHealthAdviceCells.isEmpty {
            sections.removeAll(where: {$0 == .GetHealthAdvice})
        }
        
        self.findHealthServicesSectionCells = config.findHealthServicesSectionCells.compactMap({ obj in
            if obj.value.hidden {
                return nil
            } else {
                return obj.key
        }})
        // TODO: Sort
        self.findHealthServicesSectionCells = findHealthServicesSectionCells.sorted(by: { left, right in
            return left.rawValue < right.rawValue
        })
        
        if self.findHealthServicesSectionCells.isEmpty {
            sections.removeAll(where: {$0 == .FindHealthServices})
        }
        
        self.accessHelthRecordsCells = config.accessHelthRecordsCells.compactMap({ obj in
            if obj.value.hidden {
                return nil
            } else {
                return obj.key
        }})
        // TODO: Sort
        self.accessHelthRecordsCells = accessHelthRecordsCells.sorted(by: { left, right in
            return left.rawValue < right.rawValue
        })
        
        if self.accessHelthRecordsCells.isEmpty {
            sections.removeAll(where: {$0 == .AccessHelthRecords})
        }
        
        self.usefulLinksCells = config.usefulLinksCells.compactMap({ obj in
            if obj.value.hidden {
                return nil
            } else {
                return obj.key
        }})
        // TODO: Sort
        self.usefulLinksCells = usefulLinksCells.sorted(by: { left, right in
            return left.rawValue < right.rawValue
        })
        
        if self.usefulLinksCells.isEmpty {
            sections.removeAll(where: {$0 == .UsefulLinks})
        }
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
        
        var getHealthAdviceCells: [GetHealthAdviceSection: DashboardConfig.Config] = [GetHealthAdviceSection: DashboardConfig.Config]()
        GetHealthAdviceSection.allCases.forEach { cell in
            getHealthAdviceCells[cell] = DashboardConfig.Config(index: cell.rawValue, hidden: false)
        }
        
        var findHealthServicesSectionCells: [FindHealthServicesSection: DashboardConfig.Config] = [FindHealthServicesSection: DashboardConfig.Config]()
        FindHealthServicesSection.allCases.forEach { cell in
            findHealthServicesSectionCells[cell] = DashboardConfig.Config(index: cell.rawValue, hidden: false)
        }
        
        var accessHelthRecordsCells: [AccessHelthRecords: DashboardConfig.Config] = [AccessHelthRecords: DashboardConfig.Config]()
        AccessHelthRecords.allCases.forEach { cell in
            accessHelthRecordsCells[cell] = DashboardConfig.Config(index: cell.rawValue, hidden: false)
        }
        
        var usefulLinks: [UsefulLinks: DashboardConfig.Config] = [UsefulLinks: DashboardConfig.Config]()
        UsefulLinks.allCases.forEach { cell in
            usefulLinks[cell] = DashboardConfig.Config(index: cell.rawValue, hidden: false)
        }
        
        return DashboardConfig(sections: sections,
                        connectWithProvidersSectionCells: connectWithProvidersSectionCells,
                        getHealthAdviceCells: getHealthAdviceCells,
                        findHealthServicesSectionCells: findHealthServicesSectionCells,
                        accessHelthRecordsCells: accessHelthRecordsCells,
                        usefulLinksCells: usefulLinks
        )
        
    }
}


struct DashboardConfig: Codable {
    var sections: [DashboardSections: Config]
    var connectWithProvidersSectionCells: [ConnectWithProvidersSection: Config]
    var getHealthAdviceCells: [GetHealthAdviceSection: Config]
    var findHealthServicesSectionCells: [FindHealthServicesSection: Config]
    var accessHelthRecordsCells: [AccessHelthRecords: Config]
    var usefulLinksCells: [UsefulLinks: Config]
    
    struct Config: Codable {
        var index: Int
        var hidden: Bool
    }
}
