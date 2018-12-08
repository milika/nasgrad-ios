//
//  IssueListViewController.swift
//  NasGradApp
//
//  Created by Dorian Cizmar on 12/7/18.
//  Copyright © 2018 NasGrad. All rights reserved.
//

import UIKit
import CocoaLumberjack
import MessageUI

class IssueListViewController: BaseViewController {

    // MARK: Outlets
    
    @IBOutlet weak var issuesTableView: UITableView!
    
    // MARK: Properties
    
    let networkEngine: NetworkEngineProtocol = container.resolve(NetworkEngineProtocol.self)!
    let networkRequestEngine: NetworkRequestEngineProtocol = container.resolve(NetworkRequestEngineProtocol.self)!
    var issueListService: IssueListServiceProtocol = container.resolve(IssueListServiceProtocol.self)!
    let typeService: TypeServiceProtocol = container.resolve(TypeServiceProtocol.self)!
    
    private var selectedCellIndex: Int?
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(Constants.API.apiUrl)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.title = "Svi problemi"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        fetchTypesAndCategories(withCompletionHandler: {
            self.issueListService.typeService = self.typeService
            self.fetchAllIssues()
        })
    }
    
    // MARK: Parental methods
    
    override func prepareComponents() {
        super.prepareComponents()
        issuesTableView.delegate = self
        issuesTableView.dataSource = self
    }
    
    // MARK: Style
    override func applyTheme() {
        super.applyTheme()
        self.navigationController?.navigationBar.tintColor = Theme.shared.brandColor
    }
    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueId = segue.identifier {
            if segueId == Constants.Segue.showSingleMapSegue {
                if let mapViewController = segue.destination as? SingleIssueMapViewController {
                    mapViewController.issueIndex = self.selectedCellIndex
                    mapViewController.issueListService = self.issueListService
                }
            } else if segueId == Constants.Segue.showIssueDetailsSegue {
                if let detailsViewController = segue.destination as? IssueDetailsViewController {
                    detailsViewController.detailsService.typeService = self.typeService
                    if let index = selectedCellIndex {
                        detailsViewController.issueId = issueListService.getId(forIndex: index)
                    }

                }
            }
        }
    }
    
    // MARK: Actions
    
    // MARK: Private network methods
    
    private func fetchAllIssues() {
        let allIssuesRequest = networkRequestEngine.getAllIssues()
        
        showLoader {
            self.networkEngine.performNetworkRequest(forURLRequest: allIssuesRequest, responseType: [Issue].self, completionHandler: { (data, response, error) in
                self.issueListService.setData(data)
                DDLogVerbose(String(describing: data))
                DispatchQueue.main.async {
                    hideLoader {
                        self.issuesTableView.reloadData()
                    }
                }
            })
        }
    }
    
    private func fetchTypesAndCategories(withCompletionHandler: @escaping () -> Void) {
        let getTypesRequest = networkRequestEngine.getAllTypes()
        let getCategoriesRequest = networkRequestEngine.getAllCategories()
        
        showLoader {
            self.networkEngine.performNetworkRequest(forURLRequest: getTypesRequest, responseType: [Type].self, completionHandler: { (typesData, response, error) in
                self.typeService.setTypeData(typesData)
                DDLogVerbose(String(describing: typesData))
                self.networkEngine.performNetworkRequest(forURLRequest: getCategoriesRequest, responseType: [Category].self, completionHandler: { (categoriesData, categoriesResponse, categoriesError) in
                    DDLogVerbose("\(String(describing: categoriesData))")
                    self.typeService.setCategoriesData(categoriesData)
                    DispatchQueue.main.async {
                        hideLoader {
                            withCompletionHandler()
                        }
                    }
                })
            })
        }
    }

}

extension IssueListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let map = UITableViewRowAction(style: .normal, title: NSLocalizedString(Constants.Localizable.editMap, comment: "")) { action, index in
            DDLogDebug("Map action")
            self.selectedCellIndex = indexPath.row
            self.performSegue(withIdentifier: Constants.Segue.showSingleMapSegue, sender: nil)
        }
        map.backgroundColor = Theme.shared.editButtonMapColor
        
        let submit = UITableViewRowAction(style: .normal, title: NSLocalizedString(Constants.Localizable.editSubmit, comment: "")) { action, index in
            DDLogDebug("Submit issue action")
            self.selectedCellIndex = indexPath.row
            let mailData = self.issueListService.getMailData(forIndex: indexPath.row)
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(mailData.emails)
                mail.setSubject(mailData.subject)
                mail.setMessageBody("Poštovani,<br><br>Želela / Želeo bih da prijavim sledeći problem - \(mailData.issueName)<br><br>Detalje problema (opis, slike i lokaciju na mapi) možete videti na sledećoj vebsajt stranici:<br><br><a href=\"\(mailData.issueUrl)\">\(mailData.issueUrl)", isHTML: true)
                self.present(mail, animated: true)
            }
            
        }
        submit.backgroundColor = Theme.shared.editButtonSubmitColor
        
        return [submit, map]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCellIndex = indexPath.row
        performSegue(withIdentifier: Constants.Segue.showIssueDetailsSegue, sender: nil)
    }
}

extension IssueListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issueListService.getNumberOfIssues()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: Constants.Storyboard.issueCellID, for: indexPath) as? IssueTableViewCell
        
        if cell == nil {
            cell = IssueTableViewCell(style: .default, reuseIdentifier: Constants.Storyboard.issueCellID)
        }
        
        cell?.selectionStyle = .none
        
        let issueViewData = self.issueListService.getIssueData(forIndex: indexPath.row)
        
        cell?.issueImageView?.image = issueViewData.previewImage
        cell?.titleLabel.text = issueViewData.title
        cell?.setCategory1Label(withText: issueViewData.category1Title, color: issueViewData.category1Color)
        cell?.setCategory2Label(withText: issueViewData.category2Title, color: issueViewData.category2Color)
        cell?.typeLabel.text = "Tip: \(issueViewData.type)"
        cell?.submittedNumberLabel.text = issueViewData.submittedNumber
        cell?.stateView.backgroundColor = issueViewData.stateColor
        
        return cell!
    }
}

extension IssueListViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}
