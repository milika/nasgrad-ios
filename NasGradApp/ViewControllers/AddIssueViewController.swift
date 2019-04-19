//
//  AddIssueViewController.swift
//  NasGradApp
//
//  Created by Sierra on 4/19/19.
//  Copyright © 2019 NasGrad. All rights reserved.
//

import UIKit
import CocoaLumberjack
import MessageUI

class AddIssueViewController: BaseViewController {
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    @IBOutlet weak var detailTextView: UITextView!
    
    override func viewDidAppear(_ animated: Bool) {
        var contentRect = CGRect.zero
        
        for view in mainScrollView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        contentRect.size.height += 20
        mainScrollView.contentSize = contentRect.size
        
        detailTextView.layer.borderColor = UIColor.lightGray.cgColor
        detailTextView.layer.borderWidth = 1.0
    }
}
