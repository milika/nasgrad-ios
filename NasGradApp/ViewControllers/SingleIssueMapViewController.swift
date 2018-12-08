//
//  SingleIssueMapViewController.swift
//  NasGradApp
//
//  Created by Dorian Cizmar on 12/7/18.
//  Copyright © 2018 NasGrad. All rights reserved.
//

import UIKit
import GoogleMaps

class SingleIssueMapViewController: BaseViewController {

    // MARK: Outlets
    @IBOutlet weak var singleMapView: GMSMapView!
    @IBOutlet weak var infoContainerView: UIView!
    @IBOutlet weak var issueImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var category1Label: UILabel!
    @IBOutlet weak var category2Label: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var submittedNumberLabel: UILabel!
    @IBOutlet weak var stateView: UIView!
    
    // MARK: Properties
    var issueIndex: Int?
    var issueListService: IssueListServiceProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Prikaz na mapi"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fillData()
        self.setupGoogleMapCamera()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let index = self.issueIndex, let coordinate = self.issueListService?.getSingleMapIssueData(forIndex: index).location {
            self.zoomToLocation(coordinate)
        }
        
        Theme.shared.dropShadow(forView: infoContainerView)
    }
    
    override func applyTheme() {
        super.applyTheme()
        infoContainerView.backgroundColor = Theme.shared.mapInfoViewBackgroundColor
        infoContainerView.layer.cornerRadius = Theme.shared.baseCornerRadius
        category1Label.layer.cornerRadius = Theme.shared.baseCornerRadius
        category1Label.font = Theme.shared.smallFont
        category2Label.layer.cornerRadius = Theme.shared.baseCornerRadius
        category2Label.font = Theme.shared.smallFont
        infoContainerView.clipsToBounds = true
        category1Label.clipsToBounds = true
        category2Label.clipsToBounds = true
        typeLabel.font = Theme.shared.smallFont
        submittedNumberLabel.font = Theme.shared.smallFont
        descriptionLabel.font = Theme.shared.smallFont
        stateView.layer.cornerRadius = Theme.shared.baseCornerRadius
    }
    
    override func prepareComponents() {
        super.prepareComponents()
        self.category2Label.isHidden = !(issueListService?.isSecondCategoryVisible(forId: issueIndex ?? 0) ?? true)
    }

    private func fillData() {
        if let index = issueIndex {
            let singleIssueViewData = issueListService?.getSingleMapIssueData(forIndex: index)
            issueImageView.image = singleIssueViewData?.previewImage
            titleLabel.text = singleIssueViewData?.title
            descriptionLabel.text = singleIssueViewData?.description
            category1Label.text = " \(singleIssueViewData?.category1Title ?? "") "
            category1Label.textColor = Theme.shared.baseLabelCardColor
            category1Label.backgroundColor = singleIssueViewData?.category1Color
            category2Label.text = " \(singleIssueViewData?.category2Title ?? "") "
            category2Label.textColor = Theme.shared.baseLabelCardColor
            category2Label.backgroundColor = singleIssueViewData?.category2Color
            typeLabel.text = singleIssueViewData?.type
            submittedNumberLabel.text = singleIssueViewData?.submittedNumber
            submittedNumberLabel.textColor = Theme.shared.baseLabelCardColor
            stateView.backgroundColor = singleIssueViewData?.stateColor
            if let location = singleIssueViewData?.location {
                addPinToMap(forCoordinate: location, title: "")
            }
        }
    }
    
    private func setupGoogleMapCamera() {
        if let index = issueIndex, let location = issueListService?.getSingleMapIssueData(forIndex: index).location {
            let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 10)
            singleMapView.camera = camera
        }
    }
    
    private func addPinToMap(forCoordinate: CLLocationCoordinate2D, title: String) {
        let marker = GMSMarker(position: forCoordinate)
        marker.title = title
        marker.map = singleMapView
    }
    
    private func zoomToLocation(_ location: CLLocationCoordinate2D) {
        CATransaction.begin()
        CATransaction.setValue(2, forKey: kCATransactionAnimationDuration)
        let camera = GMSCameraPosition.camera(withLatitude:location.latitude, longitude: location.longitude, zoom: 15)
        singleMapView.animate(to: camera)
        CATransaction.commit()
    }
    
}
