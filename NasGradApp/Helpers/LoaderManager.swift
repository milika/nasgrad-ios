//
//  LoaderManager.swift
//  NasGradApp
//
//  Created by Dorian Cizmar on 12/7/18.
//  Copyright © 2018 NasGrad. All rights reserved.
//

import Foundation
import UIKit

func showLoader(_ completion:@escaping() -> Void) {
    if var topController = UIApplication.shared.keyWindow?.rootViewController {
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        
        let storyboard = UIStoryboard(name: Constants.Storyboard.storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.loaderViewControllerID)
        controller.modalPresentationStyle = .overCurrentContext
        topController.present(controller, animated: false, completion: {
            completion()
        })
    }
}

func hideLoader(_ completion: @escaping() -> Void) {
    if var topController = UIApplication.shared.keyWindow?.rootViewController {
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        topController.dismiss(animated: false) {
            completion()
        }
    }
}
