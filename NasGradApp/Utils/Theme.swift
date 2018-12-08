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
    
    let brandColor = #colorLiteral(red: 1, green: 0.4666089416, blue: 0, alpha: 1)
    let editButtonMapColor = #colorLiteral(red: 1, green: 0.4666089416, blue: 0, alpha: 1)
    let editButtonSubmitColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    let mapInfoViewBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    let submittedColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
    let reportedColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 0.8069513494)
    let doneColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
    
    let baseFont = UIFont(name: "Helvetica", size: 18)
    let baseBoldFont = UIFont(name: "Helvetica-Bold ", size: 15)
    let baseTitleBoldFont = UIFont(name: "Helvetica-Bold ", size: 18)
    let smallFont = UIFont(name: "Helvetica", size: 14)
    
    let baseLabelCardColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
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
