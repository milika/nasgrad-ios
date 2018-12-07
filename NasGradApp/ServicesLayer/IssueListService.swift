//
//  AllIssuesService.swift
//  NasGradApp
//
//  Created by Dorian Cizmar on 12/7/18.
//  Copyright © 2018 NasGrad. All rights reserved.
//

import Foundation
import UIKit

typealias IssueViewData = (previewImage: UIImage, title: String, category1Title: String?, category1Color: UIColor?, category2Title: String?, category2Color: UIColor?, type: String, submittedNumber: String)

protocol IssueListServiceProtocol {
    func setData(_ data: IssuesApi?)
    func getNumberOfIssues() -> Int
    func getIssueData(forIndex: Int) -> IssueViewData
}

class IssueListService: IssueListServiceProtocol {
    
    private var data: IssuesApi?
    
    func setData(_ data: IssuesApi?) {
        self.data = data
    }
    
    func getNumberOfIssues() -> Int {
        return self.data?.issues?.count ?? 2
    }
    
    func getIssueData(forIndex: Int) -> IssueViewData {
        return IssueViewData(previewImage: #imageLiteral(resourceName: "gradskoZelenilo"), title: "Test", category1Title: "cat1", category1Color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), category2Title: "Cat 2", category2Color: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), type: "type", submittedNumber: "28")
    }
}
