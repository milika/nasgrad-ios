//
//  Utils.swift
//  NasGradApp
//
//  Created by Dorian Cizmar on 12/7/18.
//  Copyright © 2018 NasGrad. All rights reserved.
//

import Foundation
import UIKit

func getImage(fromBase64String: String) -> UIImage? {
    if let base64Data = Data(base64Encoded: fromBase64String) {
        return UIImage(data: base64Data)
    }
    return nil
}
