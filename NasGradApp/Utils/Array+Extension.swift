//
//  Array+Extension.swift
//  NasGradApp
//
//  Created by Dorian Cizmar on 12/7/18.
//  Copyright © 2018 NasGrad. All rights reserved.
//

import Foundation

extension Array {
    
    func object(atIndex index: Int) -> Element? {
        if self.count > index {
            return self[index]
        }
        return nil
    }
    
}
