//
//  Const.swift
//  NasGradApp
//
//  Created by Dorian Cizmar on 12/7/18.
//  Copyright © 2018 NasGrad. All rights reserved.
//

import Foundation
import CoreLocation

enum Environment: String {
    case release = "RELEASE"
}

struct Constants {
    
    static let googleMapsApiKey = "AIzaSyCc8eUyKVRYDY5NISTF8-lavfCdp-y86u0"
    
    static let serbiaCenterLatitude = 44.216522
    static let serbiaCenterLongitude = 20.883249
    
    struct Storyboard {
        static let storyboardName = "Main"
        static let loaderViewControllerID = "loaderViewController"
        static let issueListViewControllerID = "issueListViewController"
        static let issueCellID = "issueCell"
    }
    
    struct Segue {
        static let showIssueListSegue = "showIssueListSegue"
        static let showSingleMapSegue = "showSingleMapSegue"
        static let showIssueDetailsSegue = "showIssueDetailsSegue"
        static let showIssueTypesSegue = "showIssueTypesSegue"
    }
    
    struct Localizable {
        static let test = "test"
        static let editMap = "edit_map"
        static let editSubmit = "edit_submit"
    }
    
    struct API {
        static let apiUrl = infoForKey("Api Url")!
        
        static let getAllIssues = apiUrl + "/getissuelist"
        static let getAllTypes = apiUrl + "/Configuration"
        static let getAllCategories = apiUrl + "/Category"
        static let getIssueDetailsById = apiUrl + "/GetIssueList/GetIssueDetails"
        
         static let getNewIssueRegions = apiUrl + "/CRUD/GetAllRegions"
         static let getNewIssueCityServices = apiUrl + "/CRUD/GetAllCityServices"
         static let getNewIssueTypes = apiUrl + "/CRUD/GetAllTypes"
         static let getNewIssueCityServiceTypes = apiUrl + "/CRUD/GetAllCityServiceTypes"
        
         static let newIssue = apiUrl + "/NewIssue"
    }
    
    static let environment = Environment(rawValue: infoForKey("Environment") ?? "RELEASE") ?? .release
    
    static func infoForKey(_ key: String) -> String? {
        return (Bundle.main.infoDictionary?[key] as? String)?
            .replacingOccurrences(of: "\\", with: "")
    }
    
}
