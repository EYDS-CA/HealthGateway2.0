//
//  VisitedOnBoardingScreen.swift
//  BCVaccineCard
//
//  Created by Amir on 2021-11-23.
//

import Foundation
import UIKit

struct VisitedOnboardingScreen: Encodable, Decodable {
    let type: String
    let version: Int
    
    func geTypeEnum() -> OnboardingScreenType? {
        guard let typeID = OnboardingScreenTypeID.init(rawValue: type) else {
            return nil
        }
        return typeID.toScreenType()
    }
}

/**
 To add a new screen, add the new case here, build and follow the errors
 To update a screen version, go to Constants. -> onBoardingScreenLatestVersion()
 Check UI constraint logic in the adjustRotatingImageViewConstraints function, as constraints/assets may need to be updated
 */
enum OnboardingScreenType: Int, CaseIterable {
    case healthRecords = 0
    case dependents
    case healthPasses
    case healthResources
}

enum OnboardingScreenTypeID: String {
    case healthPasses = "healthPasses"
    case healthRecords = "healthRecords"
    case healthResources = "healthResources"
    case dependents = "dependents"
}

extension OnboardingScreenType {
     func toScreenTypeID() -> OnboardingScreenTypeID {
        switch self {
        case .healthPasses:
            return .healthPasses
        case .healthRecords:
            return .healthRecords
        case .healthResources:
            return .healthResources
        case .dependents:
            return .dependents
        }
    }
}

extension OnboardingScreenTypeID {
     func toScreenType() -> OnboardingScreenType {
        switch self {
        case .healthPasses:
            return .healthPasses
        case .healthRecords:
            return .healthRecords
        case .healthResources:
            return .healthResources
        case .dependents:
            return .dependents
        }
    }
}

extension OnboardingScreenType {
    var getResourceImage: UIImage? {
        switch self {
        case .healthPasses:
            return UIImage(named: "bubble-proofs")
        case .healthRecords:
            return UIImage(named: "bubble-records")
        case .healthResources:
            return UIImage(named: "bubble-resources")
        case .dependents:
            return UIImage(named: "bubble-dependents")
        }
    }
    // Note: Offset is:
    // Phone is 68 * 128
    var getResourceImageSizes: (width: CGFloat, height: CGFloat, xOffset: CGFloat, yOffset: CGFloat) {
        switch self {
        case .healthRecords:
            return (width: 124, height: 107, xOffset: -45, yOffset: -40)
        case .healthPasses:
            return (width: 133, height: 99, xOffset: 64, yOffset: 48)
        case .healthResources:
            return (width: 132, height: 99, xOffset: -60, yOffset: 48)
        case .dependents:
            return (width: 132, height: 99, xOffset: 64, yOffset: -10)
        }
    }
    
    var getTitle: String {
        switch self {
        case .healthPasses:
            return .healthPasses.sentenceCase()
        case .healthRecords:
            return .healthRecords.sentenceCase()
        case .healthResources:
            return .healthResources.sentenceCase()
        case .dependents:
            return .dependentRecord.sentenceCase()
        }
    }
    
    var getDescription: String {
        switch self {
        case .healthPasses:
            return .initialOnboardingHealthPassesDescription
        case .healthRecords:
            return .initialOnboardingHealthRecordsDescription
        case .healthResources:
            return .initialOnboardingHealthResourcesDescription
        case .dependents:
            return .initialOnboardingDependentRecordDescription
        }
    }
}
