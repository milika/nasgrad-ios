//
//  IssueListViewController.swift
//  NasGradApp
//
//  Created by Dorian Cizmar on 12/7/18.
//  Copyright © 2018 NasGrad. All rights reserved.
//

import UIKit

class IssueListViewController: BaseViewController {

    // MARK: Outlets
    
    @IBOutlet weak var issuesTableView: UITableView!
    
    // MARK: Properties
    
    let networkEngine: NetworkEngineProtocol? = container.resolve(NetworkEngineProtocol.self)
    let networkRequestEngine: NetworkRequestEngineProtocol? = container.resolve(NetworkRequestEngineProtocol.self)
    let issueListService: IssueListService? = container.resolve(IssueListService.self)
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(Constants.API.apiUrl)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        fetchAllIssues()
    }
    
    // MARK: Parental methods
    
    override func prepareComponents() {
        super.prepareComponents()
        issuesTableView.delegate = self
        issuesTableView.dataSource = self
    }
    
    // MARK: Style 
    
    // MARK: Actions
    
    // MARK: Private network methods
    
    private func fetchAllIssues() {
        let allIssuesRequest = networkRequestEngine?.getAllIssues()
        
        showLoader {
            self.networkEngine?.performNetworkRequest(forURLRequest: allIssuesRequest!, responseType: [Issue].self, completionHandler: { (data, response, error) in
                
                self.issueListService?.setData(data)
                hideLoader {
                    // TODO: Refresh UI
                }
            })
        }
    }

}

extension IssueListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension IssueListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: Constants.Storyboard.issueCellID, for: indexPath) as? IssueTableViewCell
        
        if cell == nil {
            cell = IssueTableViewCell(style: .default, reuseIdentifier: Constants.Storyboard.issueCellID)
        }
        
        cell?.selectionStyle = .none
        
        cell?.titleLabel.text = "Rupa na putu"
        cell?.setCategory1Label(withText: " Gradsko zelenilo ", color: Theme.shared.gradskoZeleniloColor)
        cell?.setCategory2Label(withText: nil, color: Theme.shared.gradskoZeleniloColor)
        cell?.typeLabel.text = "Rupa na putu"
        cell?.submittedNumberLabel.text = "76"
        
        return cell!
    }
}
