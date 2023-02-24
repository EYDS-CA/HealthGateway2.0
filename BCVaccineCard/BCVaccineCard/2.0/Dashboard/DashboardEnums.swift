//
//  DashboardEnums.swift
//  BCVaccineCard
//
//  Created by Amir Shayegh on 2023-02-24.
//

import UIKit

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
    case customizeDashboard = "customizeDashboard" // In app action
    case getVaccinated = "https://www.getvaccinated.gov.bc.ca/s/"
    case MSPEnrollment = "https://my.gov.bc.ca/msp/"
    
    var phoneNumber: String {
        switch self {
        case .call911: return "911"
        case .healthNavigator: return "811"
        case .registeredNurse: return "811"
        default: return ""
        }
    }
    
    var getOrderedIcons: [UIImage?]? {
        if #available(iOS 13.0, *) {
            switch self {
            case .call911:
                return [UIImage(systemName: "phone.fill")]
            case .healthNavigator:
                return [UIImage(systemName: "phone.fill")]
            case .registeredNurse:
                return [UIImage(systemName: "phone.fill"), UIImage(systemName: "message.fill"), UIImage(systemName: "video.fill")]
            case .pharmasistAdvice:
                return [UIImage(systemName: "envelope.fill")]
            case .exerciseProfessional:
                return [UIImage(systemName: "envelope.fill")]
            default: return nil
            }
        } else {
            return nil
        }
    }
    
    enum ConnectType {
        case phone
        case email
        case chat
        case videoCall
        case ignore
    }
}

enum DashboardSections: Int, CaseIterable, Codable {
    case ConnectWithHealthCareProviders
    case GetHealthAdvice
    case FindHealthServices
    case AccessHelthRecords
    case UsefulLinks
    
    func numberOfCells() -> Int {
        switch self {
        case .ConnectWithHealthCareProviders:
            return ConnectWithHealthCareProvidersSection.allCases.count
        case .GetHealthAdvice:
            return GetHealthAdviceSection.allCases.count
        case .FindHealthServices:
            return FindHealthServicesSection.allCases.count
        case .AccessHelthRecords:
            return AccessHelthRecordsSection.allCases.count
        case .UsefulLinks:
            return UsefulLinksSection.allCases.count
        }
    }
    
    func title() -> String {
        switch self {
        case .ConnectWithHealthCareProviders:
            return ""
        case .GetHealthAdvice:
            return "Get 24/7 health advice you can trust"
        case .FindHealthServices:
            return "Find health services"
        case .AccessHelthRecords:
            return "Access your health records"
        case .UsefulLinks:
            return "Other helpful links for you"
        }
    }
    
    enum ConnectWithHealthCareProvidersSection: Int, CaseIterable, Codable {
        case AccessHealthCareProfessionals
        case EmergencyCall
    }

    enum GetHealthAdviceSection: Int, CaseIterable, Codable {
        case Contact
        case IllnessesAndSymptomChecker
    }

    enum FindHealthServicesSection: Int, CaseIterable, Codable {
        case ImmunizeBCAndIslandHealth
        case MentalHealthSupport
        case serviceFinder
    }
    
    enum AccessHelthRecordsSection: Int, CaseIterable, Codable {
        case ConnectHealthGateway
    }
    
    enum UsefulLinksSection: Int, CaseIterable, Codable {
        case GetVaccinated
        case MSPEnrollment
    }

}
