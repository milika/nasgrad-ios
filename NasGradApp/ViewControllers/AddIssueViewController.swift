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

class AddIssueViewController: BaseViewController, GMSMapViewDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let networkEngine: NetworkEngineProtocol = container.resolve(NetworkEngineProtocol.self)!
    let networkRequestEngine: NetworkRequestEngineProtocol = container.resolve(NetworkRequestEngineProtocol.self)!
    
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    
    @IBOutlet weak var imageNext: UIButton!
    @IBOutlet weak var imagePrevious: UIButton!
    @IBOutlet weak var imageDelete: UIButton!
    @IBOutlet weak var imageAdd: UIButton!
     @IBOutlet weak var imagePageControl: UIPageControl!
        @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var adressLabel: UILabel!
    
    @IBOutlet weak var mapView: GMSMapView!
      @IBOutlet private weak var mapCenterPinImage: UIImageView!
    
    let locationManager = CLLocationManager()
    var lStartLocation:Bool = false
    
    var images = [UIImage]()
    var currentImageIndex:Int = 0
    
    var region:String = ""
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.region = ""
        
        detailTextView.layer.cornerRadius = 4
        detailTextView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        detailTextView.layer.borderWidth = 1.0
        
        displayImages()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       
        // updateContentSize()
       
        
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
    
    override func viewDidLayoutSubviews() {
        updateContentSize()
    }
    
    func updateContentSize() {
        var contentRect = CGRect.zero
        
        for view in mainScrollView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        contentRect.size.height += 20
        mainScrollView.contentSize = contentRect.size
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        if (lStartLocation) {
            // set current location
            let camera = GMSCameraPosition.camera(withLatitude: locValue.latitude, longitude: locValue.longitude, zoom: 15)
            mapView.camera = camera
        } else {
            manager.stopUpdatingLocation()
        }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
        lStartLocation = false
        
        let coord:CLLocationCoordinate2D = self.mapView.camera.target;
        
        
        AddressManager.shared.getAddressFromLatLon(pdblLatitude: "\(coord.latitude)", withLongitude: "\(coord.longitude)", completion: { (address, region) in
            DispatchQueue.main.async {
                self.adressLabel.text = "Adresa: \(address)"
                self.region = region
                if address == "" {
                    self.adressLabel.text = "Adresa: Nedostupno"
                } else {
                    /*
                    mapView.clear()
                    
                    let marker = GMSMarker()
                    marker.position = coord
                    marker.title = self.adressLabel.text
                    marker.snippet = self.adressLabel.text
                    marker.map = mapView
 */
                }
            }
        })
    }
    
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done() {
        /*
        val categories: List<String?>?,
        val description: String?,
        val id: String?,
        val issueType: String?,
        val location: Location?,
        val ownerId: String?,
        val state: Int?,
        val title: String?
         
         public string Id { get; set; }
         
         NasGradIssue
         public string OwnerId { get; set; }
         public string Title { get; set; }
         public string Description { get; set; }
         public List<string> CityServiceTypes { get; set; }
         public StateEnum State { get; set; }
         // public List<string> Pictures { get; set; }
         public IssueLocation Location { get; set; }
         // public string PicturePreview { get; set; }
         public int SentCount { get; set; }
         public int LikedCount { get; set; }
         public int DislikedCount { get; set; }
         public bool IsApproved { get; set; }
         
         NasGradPicture
         public string Content { get; set; }
         public bool Visible { get; set; }
         */
        
        
         var issueDict:Dictionary<String, AnyObject> = Dictionary()
        issueDict.updateValue(detailTextView?.text as AnyObject, forKey: "Description");
        issueDict.updateValue(descriptionTextField?.text as AnyObject, forKey: "Title");
        
       
        
        var pic64:String = "VBORw0KGgoAAAANSUhEUgAAAAEAAAABAQMAAAAl21bKAAAAA1BMVEX/TQBcNTh/AAAAAXRSTlPM0jRW/QAAAApJREFUeJxjYgAAAAYAAzY3fKgAAAAASUVORK5CYII=";
        
        var pictDict:Dictionary<String, AnyObject> = Dictionary()
        pictDict.updateValue(1 as AnyObject, forKey: "Id");
        pictDict.updateValue(true as AnyObject, forKey: "Visible");
        pictDict.updateValue(pic64 as AnyObject, forKey: "Content");
        
        var newIssueDict:Dictionary<String, AnyObject> = Dictionary()
        newIssueDict.updateValue(issueDict as AnyObject, forKey: "issue");
        newIssueDict.updateValue(pictDict as AnyObject, forKey: "pictureInfo");

        
          let newIssueRequest = networkRequestEngine.newIssue(params: newIssueDict)
        
        self.networkEngine.performNetworkRequest(forURLRequest: newIssueRequest, responseType: String.self /*[Type].self*/, completionHandler: { (stringData, response, error) in
            
            if !(stringData?.contains("Issue added") ?? false) {
                let alertController = UIAlertController(title: "Error submiting", message:
                    stringData, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                
                self.present(alertController, animated: true, completion: nil)
            } else {
            
              self.dismiss(animated: true, completion: nil)
            }
        })
        
      
    }
    
    // MARK: - Images Handling
    
   @IBAction func addImage() {
        let camera = DSCameraHandler(delegate_: self)
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.popoverPresentationController?.sourceView = self.view
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { (alert : UIAlertAction!) in
            camera.getCameraOn(self, canEdit: true)
        }
        let sharePhoto = UIAlertAction(title: "Photo Library", style: .default) { (alert : UIAlertAction!) in
            camera.getPhotoLibraryOn(self, canEdit: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert : UIAlertAction!) in
        }
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        
        // image is our desired image
            images.append(image)
        
        picker.dismiss(animated: true, completion: nil)
        
        displayImages()
    
    }
    
    @IBAction func nextImage() {
        currentImageIndex += 1
                displayImages()
    }
    
    @IBAction func previousImage() {
        currentImageIndex -= 1
        displayImages()
    }
    
    @IBAction func deleteImage() {
        images.remove(at: currentImageIndex)
        displayImages()
    }

    
    func displayImages() {
   
        if (images.count > 0) {
            if (currentImageIndex >= images.count) {
                currentImageIndex = images.count-1
            }
            if (currentImageIndex < 0) {
                currentImageIndex = 0
            }
            
            
            imagePageControl.currentPage = currentImageIndex;
            imagePageControl.numberOfPages = images.count;
            imagePageControl.isEnabled = false;
            
            imageView.image = images[currentImageIndex];
            
            imageNext.isEnabled = currentImageIndex < (images.count-1)
            imagePrevious.isEnabled = currentImageIndex > 0
            imageDelete.isEnabled = true
            
          
      
        } else {
            // no images
            currentImageIndex = 0;
            imageView.image = nil;
            imageNext.isEnabled = false
            imagePrevious.isEnabled = false
            imageDelete.isEnabled = false
            imagePageControl.currentPage = currentImageIndex;
            imagePageControl.numberOfPages = 1;
            imagePageControl.isEnabled = false;
        }
    }
    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueId = segue.identifier {
            if segueId == Constants.Segue.showIssueTypesSegue {
                if let issueTypesViewController = segue.destination as? IssueTypesViewController {
                    issueTypesViewController.region = self.region
                }
            }
        }
    }
  
}
