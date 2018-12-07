//
//  IssuesApi.swift
//  NasGradApp
//
//  Created by Dorian Cizmar on 12/7/18.
//  Copyright © 2018 NasGrad. All rights reserved.
//

import Foundation
struct IssuesApi: Codable {
    let issues: [Issue]?
    let count: Int?
    
    enum CodingKeys: String, CodingKey {
        case issues = "issues"
        case count = "count"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        issues = try values.decodeIfPresent([Issue].self, forKey: .issues)
        count = try values.decodeIfPresent(Int.self, forKey: .count)
    }
}
