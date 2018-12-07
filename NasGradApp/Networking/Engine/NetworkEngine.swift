//
//  NetworkEngine.swift
//  NasGradApp
//
//  Created by Dorian Cizmar on 12/7/18.
//  Copyright © 2018 NasGrad. All rights reserved.
//

import Foundation
import CocoaLumberjack

class NetworkEngine: NetworkEngineProtocol {
    var session: URLSession
    
    required init(withSession session: URLSession) {
        self.session = session
    }
    
    func performNetworkRequest<T>(forURLRequest urlRequest: URLRequest, responseType: T.Type, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) where T : Decodable {
        let dataTask = createDataTask(withRequest: urlRequest, responseType: responseType, completionHandler: completionHandler)
        dataTask.resume()
    }
    
    private func createDataTask<T: Decodable>(withRequest request: URLRequest, responseType: T.Type, completionHandler: @escaping NetworkCompletionHandler<T>) -> URLSessionDataTask {
        let dataTask = self.session.dataTask(with: request) { (data, urlResponse, error) in
            guard let receivedData = data else {
                DDLogInfo("Received data is nil")
                completionHandler(nil, urlResponse, error)
                return
            }
            
            if let decodedData = self.decodeData(data: receivedData, ofType: responseType) {
                DDLogVerbose("\(decodedData)")
                completionHandler(decodedData, urlResponse, error)
                return
            }
            
            completionHandler(nil, urlResponse, error)
        }
        
        return dataTask
    }
    
    private func decodeData<T : Decodable> (data: Data, ofType: T.Type) -> T? {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            DDLogError("Error during parsing: \(error.localizedDescription)")
        }
        return nil
    }
}
