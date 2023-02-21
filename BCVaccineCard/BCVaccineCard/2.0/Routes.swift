//
//  BasePOCViewController.swift
//  HealthGatewayTest
//
//  Created by Amir Shayegh on 2023-02-21.
//

import UIKit

fileprivate enum Storyboards {
    static var web: UIStoryboard { return UIStoryboard(name: "Web", bundle: nil) }
    static var pinDetail: UIStoryboard { return UIStoryboard(name: "PinDetail", bundle: nil) }
}

extension UIViewController {
    enum Route {
        case Web
        case PinDetail
    }
}

extension UIViewController {
    
    fileprivate func createController(route: Route) -> UIViewController? {
        let controller: UIViewController?
        switch route {
        case .Web:
            let storyboard = Storyboards.web
            controller = storyboard.instantiateViewController(withIdentifier: String(describing: WebViewController.self)) as? WebViewController
        case .PinDetail:
            let storyboard = Storyboards.pinDetail
            controller = storyboard.instantiateViewController(withIdentifier: String(describing: PinDetailViewController.self)) as? PinDetailViewController
        }
        return controller
    }
    
    func callNumber(phoneNumber:String) {
      if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {

        let application:UIApplication = UIApplication.shared
        if (application.canOpenURL(phoneCallURL)) {
            application.open(phoneCallURL, options: [:], completionHandler: nil)
        }
      }
    }
    
    func sendMail(to string: String) {
        if let url = URL(string: string) {
            UIApplication.shared.open(url)
        }
    }
}

extension UIViewController {
    func showPinDetail(pin: MapViewController.MapPin) {
        if #available(iOS 15.0, *) {
            guard let detailViewController = createController(route: .PinDetail) as? PinDetailViewController else {
                return
            }
            
            detailViewController.modalPresentationStyle = .pageSheet
            
            if let sheet = detailViewController.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
            }
            present(detailViewController, animated: true, completion: nil)
        }
    }
}

extension UIViewController {
    func showWeb(url: String, withNavigation: Bool) {
        guard let controller = createController(route: .Web) as? WebViewController else {
            return
        }
        controller.url = url
        show(controller: controller, withNavigation: withNavigation)
    }
    
    func show(route: Route, withNavigation: Bool) {
        guard let controller = createController(route: route) else {
            return
        }
        show(controller: controller, withNavigation: withNavigation)
    }
    
    func show(controller: UIViewController, withNavigation: Bool) {
        // No navigation
        if !withNavigation {
            present(controller, animated: true)
            return
        }
        // Add to existing navigation flow
        if navigationController != nil {
            controller.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(controller, animated: true)
            return
        } else {
            // New navigation flow
            let navigationController = UINavigationController(rootViewController: controller)
            controller.modalPresentationStyle = .fullScreen
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true)
            return
        }
    }
    
    func dismiss() {
        if self.parent is UINavigationController, let navController = navigationController {
            navController.dismiss(animated: true)
            return
        } else {
            self.dismiss(animated: true)
        }
    }
}
