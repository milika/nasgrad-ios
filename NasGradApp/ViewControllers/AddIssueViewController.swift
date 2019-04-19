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
import GoogleMaps
import MapKit
import CoreLocation

class AddIssueViewController: BaseViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    
    @IBOutlet weak var imageNext: UIButton!
    @IBOutlet weak var imagePrevious: UIButton!
    @IBOutlet weak var imageDelete: UIButton!
    @IBOutlet weak var imageAdd: UIButton!
    
    @IBOutlet weak var adressLabel: UILabel!
    
    @IBOutlet weak var mapView: GMSMapView!
    
    let locationManager = CLLocationManager()
    var lStartLocation:Bool = false
    
    override func viewDidAppear(_ animated: Bool) {
        var contentRect = CGRect.zero
        
        for view in mainScrollView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        contentRect.size.height += 20
        mainScrollView.contentSize = contentRect.size
        
        detailTextView.layer.cornerRadius = 4
        detailTextView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        detailTextView.layer.borderWidth = 1.0
        
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            lStartLocation = true
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        if (lStartLocation) {
            // set current location
            let camera = GMSCameraPosition.camera(withLatitude: locValue.latitude, longitude: locValue.longitude, zoom: 8)
            mapView.camera = camera
        }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
        lStartLocation = false
        
        let coord:CLLocationCoordinate2D = self.mapView.camera.target;
        
        AddressManager.shared.getAddressFromLatLon(pdblLatitude: "\(coord.latitude)", withLongitude: "\(coord.longitude)", completion: { (address) in
            DispatchQueue.main.async {
                self.adressLabel.text = "Adresa: \(address)"
                if address == "" {
                    self.adressLabel.text = "Adresa: Nedostupno"
                } else {
                    mapView.clear()
                    
                    let marker = GMSMarker()
                    marker.position = coord
                    marker.title = self.adressLabel.text
                    marker.snippet = self.adressLabel.text
                    marker.map = mapView
                }
            }
        })
    }
}
