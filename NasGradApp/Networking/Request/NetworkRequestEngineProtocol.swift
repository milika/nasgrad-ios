//
//  NetworkRequestEngineProtocol.swift
//  NasGradApp
//
//  Created by Dorian Cizmar on 12/7/18.
//  Copyright © 2018 NasGrad. All rights reserved.
//

import Foundation

protocol NetworkRequestEngineProtocol {
    func getAllIssues() -> URLRequest
    func getAllTypes() -> URLRequest
    func getAllCategories() -> URLRequest
    func getIssueDetailsById(_ byId: String) -> URLRequest
}
