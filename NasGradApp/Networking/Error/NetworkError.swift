//
//  NetworkError.swift
//  NasGradApp
//
//  Created by Dorian Cizmar on 12/7/18.
//  Copyright © 2018 NasGrad. All rights reserved.
//

import Foundation

public enum NetworkError: String, Error {
    case paramsNil = "Params are nil"
    case encodingFailed = "Encoding failed"
    case missingUrl = "Missing URL"
}
