//
//  IssueListViewController.swift
//  NasGradApp
//
//  Created by Dorian Cizmar on 12/7/18.
//  Copyright © 2018 NasGrad. All rights reserved.
//

import UIKit
import CocoaLumberjack

class IssueListViewController: BaseViewController {

    // MARK: Outlets
    
    @IBOutlet weak var issuesTableView: UITableView!
    
    // MARK: Properties
    
    let networkEngine: NetworkEngineProtocol = container.resolve(NetworkEngineProtocol.self)!
    let networkRequestEngine: NetworkRequestEngineProtocol = container.resolve(NetworkRequestEngineProtocol.self)!
    let issueListService: IssueListServiceProtocol = container.resolve(IssueListServiceProtocol.self)!
    
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
        fetchAllIssues()
    }
    
    // MARK: Parental methods
    
    override func prepareComponents() {
        super.prepareComponents()
        issuesTableView.delegate = self
        issuesTableView.dataSource = self
    }
    
    // MARK: Style
    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueId = segue.identifier {
            if segueId == Constants.Segue.showSingleMapSegue {
                if let mapViewController = segue.destination as? SingleIssueMapViewController {
                    mapViewController.issueIndex = self.selectedCellIndex
                    mapViewController.issueListService = self.issueListService
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
                hideLoader {
                    self.issuesTableView.reloadData()
                }
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
            DDLogDebug("Map action")
            self.selectedCellIndex = indexPath.row
        }
        submit.backgroundColor = Theme.shared.editButtonSubmitColor
        
        return [map, submit]
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
        
        return cell!
    }
}
