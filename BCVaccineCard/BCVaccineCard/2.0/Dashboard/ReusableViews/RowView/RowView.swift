//
//  RowView.swift
//  BCVaccineCard
//
//  Created by Connor Ogilvie on 2023-02-21.
//

import UIKit

class RowView: UIView {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var button1: UIButton!
    @IBOutlet private weak var button2: UIButton!
    @IBOutlet private weak var button3: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    
    private var type: DashboardButton?
    private weak var delegate: ButtonViewAction?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(RowView.getName, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        setup()
    }
    
    private func setup() {
        self.backgroundColor = .clear
        button1.tintColor = UIColor(hexString: "#003366")
        button2.tintColor = UIColor(hexString: "#003366")
        button3.tintColor = UIColor(hexString: "#003366")
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        titleLabel.textColor = UIColor(hexString: "#003366")
        self.contentView.layer.cornerRadius = 10.0
        contentView.clipsToBounds = true
        button3.layer.cornerRadius = button3.frame.height / 2
        button3.clipsToBounds = true
    }
    
    func configure(type: DashboardButton, owner: UITableViewCell) {
        self.type = type
        if type != .registeredNurse {
            button1.isHidden = true
            button2.isHidden = true
            button3.setImage(type.getOrderedIcons?[0], for: .normal)
        } else {
            button1.layer.cornerRadius = button1.frame.height / 2
            button1.clipsToBounds = true
            button2.layer.cornerRadius = button2.frame.height / 2
            button2.clipsToBounds = true
            button1.setImage(type.getOrderedIcons?[0], for: .normal)
            button2.setImage(type.getOrderedIcons?[1], for: .normal)
            button3.setImage(type.getOrderedIcons?[2], for: .normal)
        }
        self.titleLabel.text = type.getTitle
        self.delegate = owner as? ButtonViewAction
        if type == .call911 {
            self.titleLabel.textColor = UIColor(hexString: "#E56578")
        }
    }
    
    @IBAction private func button1Tapped(_ sender: UIButton) {
        self.delegate?.buttonTapped(type: .registeredNurse, connectType: .phone)
    }
    
    @IBAction private func button2Tapped(_ sender: UIButton) {
        self.delegate?.buttonTapped(type: .registeredNurse, connectType: .chat)
    }
    
    @IBAction private func button3Tapped(_ sender: UIButton) {
        guard let type = self.type else {
            print("ERROR NO DASH TYPE")
            return
        }
        let connectType: DashboardButton.ConnectType = type == .registeredNurse ? .videoCall : .ignore
        self.delegate?.buttonTapped(type: type, connectType: connectType)
    }

}
