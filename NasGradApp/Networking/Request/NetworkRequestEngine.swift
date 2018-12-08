//
//  NetworkRequestEngine.swift
//  NasGradApp
//
//  Created by Dorian Cizmar on 12/7/18.
//  Copyright © 2018 NasGrad. All rights reserved.
//

import Foundation

fileprivate struct HttpMethod {
    static let Get = "GET"
    static let Post = "POST"
    static let Put = "PUT"
}

class NetworkRequestEngine: NetworkRequestEngineProtocol {
    
    func getAllIssues() -> URLRequest {
        let endpointURL = URL(string: Constants.API.getAllIssues)!
        return createRequestWithUrl(endpointURL, httpMethod: HttpMethod.Get, params: nil)!
    }
    
    func getAllTypes() -> URLRequest {
        let endpointURL = URL(string: Constants.API.getAllTypes)!
        return createRequestWithUrl(endpointURL, httpMethod: HttpMethod.Get, params: nil)!
    }
    
    func getAllCategories() -> URLRequest {
        let endpointURL = URL(string: Constants.API.getAllCategories)!
        return createRequestWithUrl(endpointURL, httpMethod: HttpMethod.Get, params: nil)!
    }
    
    func getIssueDetailsById(_ byId: String) -> URLRequest {
        let endpointURL = URL(string: Constants.API.getIssueDetailsById + "/\(byId)")!
        return createRequestWithUrl(endpointURL, httpMethod: HttpMethod.Get, params: nil)!
    }
    
    private func createRequestWithUrl(_ url: URL, httpMethod: String, params: Dictionary<String, AnyObject>?) -> URLRequest? {
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = httpMethod
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if let _ = params {
            if (httpMethod == HttpMethod.Post) {
                let postData: Data? = try? JSONSerialization.data(withJSONObject: params!, options: JSONSerialization.WritingOptions(rawValue: 0))
                
                guard let _ = postData else {
                    return nil
                }
                
                urlRequest.httpBody = postData
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            } else if (httpMethod == HttpMethod.Get) {
                var components = URLComponents(string: url.absoluteString)
                components?.queryItems = params!.map { eachDict in
                    URLQueryItem(name: eachDict.key, value: eachDict.value.description ?? "")
                }
                urlRequest.url = components?.url
            }
        }
        
        return urlRequest
    }
}
