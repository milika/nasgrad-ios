//
//  IssueTableViewCell.swift
//  NasGradApp
//
//  Created by Dorian Cizmar on 12/7/18.
//  Copyright © 2018 NasGrad. All rights reserved.
//

import UIKit

class IssueTableViewCell: UITableViewCell {

    // MARK: Outlets
    
    @IBOutlet weak var issueImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var category1Label: UILabel!
    @IBOutlet weak var category2Label: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var submittedNumberLabel: UILabel!
    @IBOutlet weak var stateView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyTheme()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
    }

    // MARK: Theme
    
    private func applyTheme() {
        category1Label.font = Theme.shared.smallFont
        category2Label.font = Theme.shared.smallFont
        typeLabel.font = Theme.shared.smallFont
        submittedNumberLabel.font = Theme.shared.smallFont
        
        category1Label.textColor = Theme.shared.baseLabelCardColor
        category2Label.textColor = Theme.shared.baseLabelCardColor
        submittedNumberLabel.textColor = Theme.shared.baseLabelCardColor

        issueImageView?.layer.cornerRadius = Theme.shared.baseCornerRadius
        category1Label.layer.cornerRadius = Theme.shared.baseCornerRadius
        category2Label.layer.cornerRadius = Theme.shared.baseCornerRadius
        stateView.layer.cornerRadius = Theme.shared.baseCornerRadius
        
        issueImageView.clipsToBounds = true
        category1Label.clipsToBounds = true
        category2Label.clipsToBounds = true
        stateView.clipsToBounds = true
    }
    
    // MARK: Public Api
    
    func setCategory1Label(withText: String?, color: UIColor?) {
        self.category1Label.text = " \(withText ?? "") "
        self.category1Label.backgroundColor = color
        self.category2Label.isHidden = true
    }
    
    func setCategory2Label(withText: String?, color: UIColor?) {
        if let withText = withText {
            self.category2Label.isHidden = false
            self.category2Label.text = " \(withText) "
            self.category2Label.backgroundColor = color
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
