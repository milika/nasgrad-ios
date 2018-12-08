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
    
    let editButtonMapColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    let editButtonSubmitColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    let mapInfoViewBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    let baseFont = UIFont(name: "Helvetica", size: 18)
    let baseBoldFont = UIFont(name: "Helvetica-Bold ", size: 15)
    let baseTitleBoldFont = UIFont(name: "Helvetica-Bold ", size: 18)
    let smallFont = UIFont(name: "Helvetica", size: 14)
    
    let baseCornerRadius: CGFloat = 4
    
    func dropShadow(forView view: UIView) {
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: -1, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
        
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
    }

}
