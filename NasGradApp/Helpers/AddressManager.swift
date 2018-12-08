//
//  AddressManager.swift
//  NasGradApp
//
//  Created by Dorian Cizmar on 12/8/18.
//  Copyright © 2018 NasGrad. All rights reserved.
//

import Foundation
import CoreLocation

class AddressManager {
    static let shared = AddressManager()
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String, completion: @escaping (String) -> Void) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        let lon: Double = Double("\(pdblLongitude)")!
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                    completion("")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    var addressString : String = ""
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    
                    completion(addressString)
                } else {
                    completion("")
                }
        })
        
    }
}
