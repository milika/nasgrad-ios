//
//  LoaderViewController.swift
//  NasGradApp
//
//  Created by Dorian Cizmar on 12/7/18.
//  Copyright © 2018 NasGrad. All rights reserved.
//

import UIKit

class LoaderViewController: UIViewController {
    
    @IBOutlet weak var loaderIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loaderIndicator.startAnimating()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        loaderIndicator.stopAnimating()
    }
    
}
