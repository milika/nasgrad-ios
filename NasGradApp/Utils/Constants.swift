//
//  Const.swift
//  NasGradApp
//
//  Created by Dorian Cizmar on 12/7/18.
//  Copyright © 2018 NasGrad. All rights reserved.
//

import Foundation

enum Environment: String {
    case release = "RELEASE"
}

struct Constants {
    
    struct Storyboard {
        static let storyboardName = "Main"
        static let loaderViewControllerID = "loaderViewController"
        static let issueListViewControllerID = "issueListViewController"
        static let issueCellID = "issueCell"
    }
    
    struct Segue {
        static let showIssueListSegue = "showIssueListSegue"
    }
    
    struct Localizable {
        static let test = "test"
    }
    
    struct API {
        static let apiUrl = infoForKey("Api Url")!
        
        static let getAllIssues = apiUrl + "/getissuelist"
        static let getAllTypes = apiUrl + "/types"
    }
    
    static let environment = Environment(rawValue: infoForKey("Environment") ?? "RELEASE") ?? .release
    
    static func infoForKey(_ key: String) -> String? {
        return (Bundle.main.infoDictionary?[key] as? String)?
            .replacingOccurrences(of: "\\", with: "")
    }
    
}
