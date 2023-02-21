//
//  RowView.swift
//  BCVaccineCard
//
//  Created by Connor Ogilvie on 2023-02-21.
//

import UIKit

class RowView: UIView {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var iconImageView: UIImageView!
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
        iconImageView.tintColor = UIColor(hexString: "#003366")
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        titleLabel.textColor = UIColor(hexString: "#003366")
        self.contentView.layer.cornerRadius = 10.0
        contentView.clipsToBounds = true
    }
    
    func configure(type: DashboardButton, owner: UITableViewCell) {
        self.type = type
        self.iconImageView.image = type.getIcon
        self.titleLabel.text = type.getTitle
        self.delegate = owner as? ButtonViewAction
        if type == .call911 {
            self.iconImageView.tintColor = UIColor(hexString: "#E56578")
            self.titleLabel.textColor = UIColor(hexString: "#E56578")
        }
    }
    
    @IBAction private func buttonTapped(_ sender: UIButton) {
        guard let type = self.type else {
            print("ERROR NO DASH TYPE")
            return
        }
        self.delegate?.buttonTapped(type: type)
    }

}
