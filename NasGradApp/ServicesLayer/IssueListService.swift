//
//  AllIssuesService.swift
//  NasGradApp
//
//  Created by Dorian Cizmar on 12/7/18.
//  Copyright © 2018 NasGrad. All rights reserved.
//

import Foundation

protocol IssueListServiceProtocol {
    func setData(_ data: [Issue]?)
    func getAllIssues() -> [Issue]
}

class IssueListService: IssueListServiceProtocol {
    
    private var data: [Issue]?
    
    func setData(_ data: [Issue]?) {
        self.data = data
    }
    
    func getAllIssues() -> [Issue] {
        return []
    }
    
}
