//
//  AllIssuesService.swift
//  NasGradApp
//
//  Created by Dorian Cizmar on 12/7/18.
//  Copyright © 2018 NasGrad. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

typealias IssueViewData = (previewImage: UIImage?, title: String, category1Title: String?, category1Color: UIColor?, category2Title: String?, category2Color: UIColor?, type: String, submittedNumber: String)

typealias MapIssueViewData = (previewImage: UIImage?, title: String, description: String?, category1Title: String?, category1Color: UIColor?, category2Title: String?, category2Color: UIColor?, type: String, submittedNumber: String, location: CLLocationCoordinate2D)

protocol IssueListServiceProtocol {
    func setData(_ data: [Issue]?)
    func getNumberOfIssues() -> Int
    func getIssueData(forIndex: Int) -> IssueViewData
    func getSingleMapIssueData(forIndex: Int) -> MapIssueViewData
    func isSecondCategoryVisible() -> Bool
}

class IssueListService: IssueListServiceProtocol {
    
    private var data: [Issue]?
    
    func setData(_ data: [Issue]?) {
        self.data = data
    }
    
    func getNumberOfIssues() -> Int {
        return self.data?.count ?? 0
    }
    
    func getIssueData(forIndex: Int) -> IssueViewData {
        if let issue = data?.object(atIndex: forIndex) {
            let previewImage = getImage(fromBase64String: issue.picturePreview ?? "")
            return IssueViewData(previewImage: previewImage, title: issue.title!, category1Title: "Gradsko zelenilo", category1Color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 0.5037508878), category2Title: "Putevi NS", category2Color: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 0.5), type: issue.issueType ?? "", submittedNumber: "28")
        }
        return IssueViewData(previewImage: #imageLiteral(resourceName: "gradskoZelenilo"), title: "Nema podataka", category1Title: nil, category1Color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), category2Title: nil, category2Color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), type: "", submittedNumber: "0")
    }
    
    func getSingleMapIssueData(forIndex: Int) -> MapIssueViewData {
        return MapIssueViewData(previewImage: #imageLiteral(resourceName: "gradskoZelenilo"), title: "Rupa na putu na Bulevaru Oslobodjenja", description: "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.", category1Title: "Gradsko zelenilo", category1Color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 0.5044611151), category2Title: "Putevi NS", category2Color: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 0.5), type: "Rupa na putu", submittedNumber: "28", location: CLLocationCoordinate2D(latitude: 45.262283, longitude: 19.835551))
    }
    
    func isSecondCategoryVisible() -> Bool {
        return true
    }
}

class IssueListServiceMock: IssueListServiceProtocol {
    
    func setData(_ data: [Issue]?) {
        
    }
    
    func getNumberOfIssues() -> Int {
        return 2
    }
    
    func getIssueData(forIndex: Int) -> IssueViewData {
        return IssueViewData(previewImage: #imageLiteral(resourceName: "gradskoZelenilo"), title: "Rupa na putu na Bulevaru Oslobodjenja", category1Title: "Gradsko zelenilo", category1Color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), category2Title: "Putevi NS", category2Color: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), type: "Rupa na putu", submittedNumber: "28")
    }
    
    func getSingleMapIssueData(forIndex: Int) -> MapIssueViewData {
        return MapIssueViewData(previewImage: #imageLiteral(resourceName: "gradskoZelenilo"), title: "Rupa na putu na Bulevaru Oslobodjenja", description: "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.", category1Title: "Gradsko zelenilo", category1Color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), category2Title: "Putevi NS", category2Color: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), type: "Rupa na putu", submittedNumber: "28", location: CLLocationCoordinate2D(latitude: 45.262283, longitude: 19.835551))
    }
    
    func isSecondCategoryVisible() -> Bool {
        return false
    }
}
