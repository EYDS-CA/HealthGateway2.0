//
//  PinDetailViewController.swift
//  BCVaccineCard
//
//  Created by Amir Shayegh on 2023-02-21.
//

import UIKit


class PinDetailViewController: BaseStaticImageViewController {

    @IBAction private func backButtonHackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
