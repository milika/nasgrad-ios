//
//  NetworkEngineProtocol.swift
//  NasGradApp
//
//  Created by Dorian Cizmar on 12/7/18.
//  Copyright © 2018 NasGrad. All rights reserved.
//

import Foundation

typealias NetworkCompletionHandler<T : Decodable> = (T?, URLResponse?, Error?) -> Void

protocol NetworkEngineProtocol {
    func performNetworkRequest<T: Decodable>(forURLRequest urlRequest: URLRequest, responseType: T.Type, completionHandler: @escaping NetworkCompletionHandler<T>)
}
