//
//  IssuesMapViewController.swift
//  NasGradApp
//
//  Created by Dorian Cizmar on 12/8/18.
//  Copyright © 2018 NasGrad. All rights reserved.
//

import UIKit
import GoogleMaps

class IssuesMapViewController: BaseViewController {

    @IBOutlet weak var allIssuesMapView: GMSMapView!
    @IBOutlet weak var infoContainerView: UIView!
    @IBOutlet weak var issueImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var category1Label: UILabel!
    @IBOutlet weak var category2Label: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var stateView: UIView!
    @IBOutlet weak var submittedNumberLabel: UILabel!
    
    var allIssuesMapService: IssueListServiceProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let issueListViewController = (tabBarController?.viewControllers?.object(atIndex: 0) as! UINavigationController).viewControllers.object(atIndex: 0) as? IssueListViewController {
            self.allIssuesMapService = issueListViewController.issueListService
        }
        allIssuesMapView.clear()
        addPinsToMap()
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
        allIssuesMapView.delegate = self
        self.infoContainerView.alpha = 0
        setupGoogleMapCamera()
    }
    
    private func addPinsToMap() {
        allIssuesMapService?.getAllLocations().forEach({ location in
            addPinToMap(forCoordinate: location.0, title: "", id: location.1)
        })
    }
    
    private func addPinToMap(forCoordinate: CLLocationCoordinate2D, title: String, id: String = "") {
        let marker = GMSMarker(position: forCoordinate)
        marker.title = title
        marker.userData = id
        marker.map = allIssuesMapView
    }
    
    private func zoomToLocation(_ location: CLLocationCoordinate2D) {
        CATransaction.begin()
        CATransaction.setValue(1, forKey: kCATransactionAnimationDuration)
        let camera = GMSCameraPosition.camera(withLatitude:location.latitude, longitude: location.longitude, zoom: 25)
        allIssuesMapView.animate(to: camera)
        CATransaction.commit()
    }
    
    private func setupGoogleMapCamera() {
        let camera = GMSCameraPosition.camera(withLatitude: Constants.serbiaCenterLatitude, longitude: Constants.serbiaCenterLongitude, zoom: 7)
        allIssuesMapView.camera = camera
    }
    
    private func fillData(forIssueIdentifier: String) {

            let singleIssueViewData = allIssuesMapService?.getMapIssueData(forIdentifier: forIssueIdentifier)
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

extension IssuesMapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let id = marker.userData as? String {
            fillData(forIssueIdentifier: id)
            UIView.animate(withDuration: 1) {
                self.infoContainerView.alpha = 1
            }
        }
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        UIView.animate(withDuration: 1) {
            self.infoContainerView.alpha = 0
        }
    }
}
