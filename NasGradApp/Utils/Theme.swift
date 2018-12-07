//
//  Theme.swift
//  NasGradApp
//
//  Created by Dorian Cizmar on 12/7/18.
//  Copyright © 2018 NasGrad. All rights reserved.
//

import Foundation
import UIKit

class Theme {
    static let shared = Theme()
    
    let gradskoZeleniloColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
    let putNoviSadColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    
    let baseFont = UIFont(name: "Helvetica", size: 18)
    let baseBoldFont = UIFont(name: "Helvetica-Bold ", size: 15)
    let baseTitleBoldFont = UIFont(name: "Helvetica-Bold ", size: 18)
    let smallFont = UIFont(name: "Helvetica", size: 14)
    
    let baseCornerRadius: CGFloat = 4
}