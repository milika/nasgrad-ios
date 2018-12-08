//
//  TypeService.swift
//  NasGradApp
//
//  Created by Dorian Cizmar on 12/8/18.
//  Copyright © 2018 NasGrad. All rights reserved.
//

import Foundation

protocol TypeServiceProtocol {
    func setTypeData(_ data: [Type]?)
    func setCategoriesData(_ data: [Category]?)
    
    func getCategoryById(_ id: String) -> Category?
    func getTypeById(_ id: String) -> Type?
}

class TypeService: TypeServiceProtocol {
    
    private var typeData: [Type]?
    private var categoriesData: [Category]?
    
    func setTypeData(_ data: [Type]?) {
        self.typeData = data
    }
    
    func setCategoriesData(_ data: [Category]?) {
        self.categoriesData = data
    }
    
    func getTypeById(_ id: String) -> Type? {
        return self.typeData?.filter({$0.id == id}).first
    }
    
    func getCategoryById(_ id: String) -> Category? {
        return self.categoriesData?.filter({$0.id == id}).first
    }
}
