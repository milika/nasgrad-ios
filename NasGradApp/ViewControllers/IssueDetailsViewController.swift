//
//  IssueDetailsViewController.swift
//  NasGradApp
//
//  Created by Dorian Cizmar on 12/8/18.
//  Copyright © 2018 NasGrad. All rights reserved.
//

import UIKit
import MessageUI

class IssueDetailsViewController: BaseViewController {

    // MARK: Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var issueImageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var category1Label: UILabel!
    @IBOutlet weak var category2Label: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    
    let networkEngine: NetworkEngineProtocol = container.resolve(NetworkEngineProtocol.self)!
    let networkRequestEngine: NetworkRequestEngineProtocol = container.resolve(NetworkRequestEngineProtocol.self)!
    var detailsService: IssueDetailsServiceProtocol = container.resolve(IssueDetailsServiceProtocol.self)!
    
    var issueId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationButton.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.title = "Detalji problema"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        fetchIssueDetails()
    }
    
    override func applyTheme() {
        super.applyTheme()
        typeLabel.font = Theme.shared.smallFont
        category1Label.font = Theme.shared.smallFont
        category2Label.font = Theme.shared.smallFont
        locationLabel.font = Theme.shared.smallFont
        descriptionLabel.font = Theme.shared.smallFont
        
        issueImageView.layer.cornerRadius = Theme.shared.baseCornerRadius
        category1Label.layer.cornerRadius = Theme.shared.baseCornerRadius
        category2Label.layer.cornerRadius = Theme.shared.baseCornerRadius
        
        category1Label.textColor = Theme.shared.baseLabelCardColor
        category2Label.textColor = Theme.shared.baseLabelCardColor
        
        submitButton.layer.cornerRadius = Theme.shared.baseCornerRadius
        submitButton.setTitleColor(Theme.shared.baseLabelCardColor, for: .normal)
        submitButton.backgroundColor = Theme.shared.brandColor
        
        issueImageView.clipsToBounds = true
        category1Label.clipsToBounds = true
        category2Label.clipsToBounds = true
    }
    
    private func fillData() {
        if let viewData = self.detailsService.getViewData() {
            titleLabel.text = viewData.title
            issueImageView.image = viewData.images?.first
            typeLabel.text = "Tip: \(viewData.type ?? "")"
            category1Label.text = viewData.category1Title
            category2Label.text = viewData.category2Title
            category1Label.backgroundColor = viewData.category1Color
            category2Label.backgroundColor = viewData.category2Color
            descriptionLabel.text = "Opis: \(viewData.description ?? "")"
        }
    }
    
    @IBAction func locationAction(_ sender: Any) {
        
    }
    
    @IBAction func submitAction(_ sender: Any) {
        let mailData = self.detailsService.getMailData()
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(mailData.emails)
            mail.setSubject(mailData.subject)
            mail.setMessageBody("Poštovani,<br><br>Želela / Želeo bih da prijavim sledeći problem - \(mailData.issueName)<br><br>Detalje problema (opis, slike i lokaciju na mapi) možete videti na sledećoj vebsajt stranici:<br><br><a href=\"\(mailData.issueUrl)\">\(mailData.issueUrl)", isHTML: true)
            self.present(mail, animated: true)
        }
    }
    
    private func fetchIssueDetails() {
        if let id = issueId {
            let issueDetailsRequest = networkRequestEngine.getIssueDetailsById(id)
            
            showLoader {
                self.networkEngine.performNetworkRequest(forURLRequest: issueDetailsRequest, responseType: Issue.self) { (detailsData, response, error) in
                    self.detailsService.setData(detailsData)
                    
                    AddressManager.shared.getAddressFromLatLon(pdblLatitude: "\(self.detailsService.getViewData()?.location?.latitude ?? -1)", withLongitude: "\(self.detailsService.getViewData()?.location?.longitude ?? -1)", completion: { (address) in
                        DispatchQueue.main.async {
                            self.locationLabel.text = "Adresa: \(address)"
                            if address == "" {
                                self.locationLabel.text = "Adresa: Nedostupno"
                            }
                            hideLoader {
                                self.fillData()
                            }
                        }
                    })
                }
            }
        }
    }

}

extension IssueDetailsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}
