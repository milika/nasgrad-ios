//
//  DependencyInjectionContainer.swift
//  NasGradApp
//
//  Created by Dorian Cizmar on 12/7/18.
//  Copyright © 2018 NasGrad. All rights reserved.
//

import Foundation
import Swinject

var container: Container {
    let container = Container()
    
    container.register(URLSession.self) { _ in
        return URLSession(configuration: .default)
    }
    
    container.register(NetworkEngineProtocol.self, factory: { resolver in
        let urlSession = resolver.resolve(URLSession.self)!
        return NetworkEngine(withSession: urlSession)
    })
    
    container.register(NetworkRequestEngineProtocol.self) { _ in
        return NetworkRequestEngine()
    }
    
    container.register(IssueListServiceProtocol.self) { _ in
        return IssueListService()
    }
    
    container.register(TypeServiceProtocol.self) { _ in
        return TypeService()
    }
    
    container.register(IssueDetailsServiceProtocol.self) { _ in
        return IssueDetailsService()
    }
    
    return container
}
