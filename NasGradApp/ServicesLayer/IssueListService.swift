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

typealias IssueViewData = (previewImage: UIImage?, title: String, category1Title: String?, category1Color: UIColor?, category2Title: String?, category2Color: UIColor?, type: String, submittedNumber: String, stateColor: UIColor?)

typealias MapIssueViewData = (previewImage: UIImage?, title: String, description: String?, category1Title: String?, category1Color: UIColor?, category2Title: String?, category2Color: UIColor?, type: String, submittedNumber: String, location: CLLocationCoordinate2D, stateColor: UIColor?)

typealias MailData = (emails: [String], subject: String, issueUrl: String, issueName: String)

protocol IssueListServiceProtocol {
    var typeService: TypeServiceProtocol? { set get }
    
    func setData(_ data: [Issue]?)
    func getNumberOfIssues() -> Int
    func getIssueData(forIndex: Int) -> IssueViewData
    func getSingleMapIssueData(forIndex: Int) -> MapIssueViewData
    func isSecondCategoryVisible(forId: Int) -> Bool
    func getAllLocations() -> [(CLLocationCoordinate2D, String)]
    func getMapIssueData(forIdentifier: String) -> MapIssueViewData
    func getMailData(forIndex: Int) -> MailData
    func getId(forIndex: Int) -> String?
}

class IssueListService: IssueListServiceProtocol {
    
    var typeService: TypeServiceProtocol?
    
    private var data: [Issue]?
    
    func setData(_ data: [Issue]?) {
        self.data = data
    }
    
    func getNumberOfIssues() -> Int {
        return self.data?.count ?? 0
    }
    
    func getIssueData(forIndex: Int) -> IssueViewData {
        if let issue = data?.object(atIndex: forIndex) {
            return getIssueViewData(fromIssue: issue)
        }
        return IssueViewData(previewImage: #imageLiteral(resourceName: "gradskoZelenilo"), title: "Nema podataka", category1Title: nil, category1Color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), category2Title: nil, category2Color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), type: "", submittedNumber: "0", stateColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    }
    
    func getSingleMapIssueData(forIndex: Int) -> MapIssueViewData {
        
        if let issue = data?.object(atIndex: forIndex) {
            return getViewData(fromIssue: issue)
        }
        
        return MapIssueViewData(previewImage: #imageLiteral(resourceName: "gradskoZelenilo"), title: "Rupa na putu na Bulevaru Oslobodjenja", description: "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.", category1Title: "Gradsko zelenilo", category1Color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 0.5044611151), category2Title: "Putevi NS", category2Color: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 0.5), type: "Rupa na putu", submittedNumber: "28", location: CLLocationCoordinate2D(latitude: 45.262283, longitude: 19.835551), stateColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    }
    
    func isSecondCategoryVisible(forId: Int) -> Bool {
        return (data?.object(atIndex: forId)?.categories?.count ?? 0) > 1
    }
    
    func getAllLocations() -> [(CLLocationCoordinate2D, String)] {
        var locations = [(CLLocationCoordinate2D, String)]()
        data?.forEach({ issue in
            if let latitude = issue.location?.latitude, let longitude = issue.location?.longitude {
                locations.append((CLLocationCoordinate2D(latitude: latitude, longitude: longitude), issue.id ?? ""))
            }
        })
        return locations
    }
    
    func getMapIssueData(forIdentifier: String) -> MapIssueViewData {
        if let issue = data?.filter({$0.id == forIdentifier}).first {
            return getViewData(fromIssue: issue)
        }
        
        return MapIssueViewData(previewImage: #imageLiteral(resourceName: "gradskoZelenilo"), title: "Rupa na putu na Bulevaru Oslobodjenja", description: "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.", category1Title: "Gradsko zelenilo", category1Color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 0.5044611151), category2Title: "Putevi NS", category2Color: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 0.5), type: "Rupa na putu", submittedNumber: "28", location: CLLocationCoordinate2D(latitude: 45.262283, longitude: 19.835551), stateColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    }
    
    private func getIssueViewData(fromIssue issue: Issue) -> IssueViewData {
        let previewImage = getImage(fromBase64String: issue.picturePreview ?? "")
        
        let category1Id = issue.categories?.object(atIndex: 0) ?? ""
        let category2Id = issue.categories?.object(atIndex: 1) ?? ""
        
        let category1 = typeService?.getCategoryById(category1Id)
        let category2 = typeService?.getCategoryById(category2Id)
        
        var cat1Color: UIColor? = nil
        var cat2Color: UIColor? = nil
        
        if let hex1 = category1?.color {
            cat1Color = hexStringToUIColor(hex: hex1)
        }
        
        if let hex2 = category2?.color {
            cat2Color = hexStringToUIColor(hex: hex2)
        }
        
        let type = typeService?.getTypeById(issue.issueType ?? "")
        
        var stateColor: UIColor? = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        
        if let state = issue.state {
            if state == 1 {
                stateColor = Theme.shared.submittedColor
            } else if state == 2 {
                stateColor = Theme.shared.reportedColor
            } else if state == 3 {
                stateColor = Theme.shared.doneColor
            }
        }
        
        return IssueViewData(previewImage: previewImage, title: issue.title!, category1Title: category1?.name, category1Color: cat1Color, category2Title: category2?.name, category2Color: cat2Color, type: type?.name ?? "", submittedNumber: "\(issue.submittedCount ?? 0)", stateColor: stateColor)
    }
    
    private func getViewData(fromIssue issue: Issue) -> MapIssueViewData {
        let issueData = getIssueViewData(fromIssue: issue)
        let latitude = issue.location?.latitude ?? -1
        let longitude = issue.location?.longitude ?? -1
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        return MapIssueViewData(previewImage: issueData.previewImage, title: issueData.title, description: issue.description, category1Title: issueData.category1Title, category1Color: issueData.category1Color, category2Title: issueData.category2Title, category2Color: issueData.category2Color, type: issueData.type, submittedNumber: issueData.submittedNumber, location: location, stateColor: issueData.stateColor)
    }
    
    func getMailData(forIndex: Int) -> MailData {
        if let issue = self.data?.object(atIndex: forIndex) {
            var emails = [String]()
            issue.categories?.forEach({ (catId) in
                if let category = self.typeService?.getCategoryById(catId) {
                    if let mail = category.email {
                        emails.append(mail)
                    }
                }
            })
            
            return MailData(emails: emails, subject: "Komunalna prijava (#NasGradApp \(issue.id!)", issueUrl: "\(Constants.API.apiUrl)/issuedetail/\(issue.id!)", issueName: issue.title ?? "")
        }
        return MailData(emails: [], subject: "", issueUrl: "", issueName: "")
    }
    
    func getId(forIndex: Int) -> String? {
        return self.data?.object(atIndex: forIndex)?.id
    }
}
