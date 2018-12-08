//
//  IssueListServiceMock.swift
//  NasGradApp
//
//  Created by Dorian Cizmar on 12/8/18.
//  Copyright © 2018 NasGrad. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class IssueListServiceMock: IssueListServiceProtocol {
    
    var typeService: TypeServiceProtocol?
    
    func setData(_ data: [Issue]?) {
        
    }
    
    func getNumberOfIssues() -> Int {
        return 2
    }
    
    func getIssueData(forIndex: Int) -> IssueViewData {
        return IssueViewData(previewImage: #imageLiteral(resourceName: "gradskoZelenilo"), title: "Rupa na putu na Bulevaru Oslobodjenja", category1Title: "Gradsko zelenilo", category1Color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), category2Title: "Putevi NS", category2Color: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), type: "Rupa na putu", submittedNumber: "28", stateColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))
    }
    
    func getSingleMapIssueData(forIndex: Int) -> MapIssueViewData {
        return MapIssueViewData(previewImage: #imageLiteral(resourceName: "gradskoZelenilo"), title: "Rupa na putu na Bulevaru Oslobodjenja", description: "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.", category1Title: "Gradsko zelenilo", category1Color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), category2Title: "Putevi NS", category2Color: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), type: "Rupa na putu", submittedNumber: "28", location: CLLocationCoordinate2D(latitude: 45.262283, longitude: 19.835551), stateColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))
    }
    
    func isSecondCategoryVisible(forId: Int) -> Bool {
        return false
    }
    
    func getAllLocations() -> [(CLLocationCoordinate2D, String)] {
        return [(CLLocationCoordinate2D(latitude: 45.256917, longitude: 19.841641), "")]
    }
    
    func getMapIssueData(forIdentifier: String) -> MapIssueViewData {
        return MapIssueViewData(previewImage: #imageLiteral(resourceName: "gradskoZelenilo"), title: "Rupa na putu na Bulevaru Oslobodjenja", description: "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.", category1Title: "Gradsko zelenilo", category1Color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), category2Title: "Putevi NS", category2Color: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), type: "Rupa na putu", submittedNumber: "28", location: CLLocationCoordinate2D(latitude: 45.262283, longitude: 19.835551), stateColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))
    }
    
    func getMailData(forIndex: Int) -> MailData {
        return MailData(emails: [], subject: "", issueUrl: "", issueName: "")
    }
    
    func getId(forIndex: Int) -> String? {
        return nil
    }
}
