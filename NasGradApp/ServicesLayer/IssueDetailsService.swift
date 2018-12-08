//
//  IssueDetailsService.swift
//  NasGradApp
//
//  Created by Dorian Cizmar on 12/8/18.
//  Copyright © 2018 NasGrad. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

typealias IssueDetailsViewData = (title: String?, images: [UIImage]?, type: String?, category1Title: String?, category1Color: UIColor?, category2Title: String?, category2Color: UIColor?, address: String?, location: CLLocationCoordinate2D?, description: String?)

protocol IssueDetailsServiceProtocol {
    var typeService: TypeServiceProtocol? { get set }
    
    func setData(_ data: Issue?)
    func getViewData() -> IssueDetailsViewData?
    func getMailData() -> MailData
}

class IssueDetailsService: IssueDetailsServiceProtocol {
    
    private var data: Issue?
    var typeService: TypeServiceProtocol?
    
    func setData(_ data: Issue?) {
        self.data = data
    }
    
    func getViewData() -> IssueDetailsViewData? {
        if let issue = data {
            return getIssueDetailsViewData(fromIssue: issue)
        }
        return nil
    }
    
    private func getIssueDetailsViewData(fromIssue: Issue) -> IssueDetailsViewData {
        
        var images = [UIImage]()
        fromIssue.pictures?.forEach({ (base64String) in
            if let image = getImage(fromBase64String: base64String) {
                images.append(image)
            }
        })
        
        let picture = getImage(fromBase64String: fromIssue.picturePreview ?? "") ?? #imageLiteral(resourceName: "gradskoZelenilo")
        
        let type = typeService?.getTypeById(fromIssue.issueType ?? "")
        
        let category1Id = fromIssue.categories?.object(atIndex: 0) ?? ""
        let category2Id = fromIssue.categories?.object(atIndex: 1) ?? ""
        
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
        
        let latitude = fromIssue.location?.latitude ?? -1
        let longitude = fromIssue.location?.longitude ?? -1
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let address = "Bulevar oslobodjenja" // TODO: Fetch this data depends on lat/long
        
        return IssueDetailsViewData(title: fromIssue.title, images: [picture], type: type?.name, category1Title: category1?.name, category1Color: cat1Color, category2Title: category2?.name, category2Color: cat2Color, address: address, location: location, description: fromIssue.description)
    }
    
    func getMailData() -> MailData {
        if let issue = self.data {
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
    
    
}
