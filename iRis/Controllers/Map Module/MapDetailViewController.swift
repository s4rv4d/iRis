//
//  MapDetailViewController.swift
//  iRis
//
//  Created by Sarvad shetty on 12/14/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit
import GoogleMaps

class MapDetailViewController: UIViewController {
    
    //MARK: - Variables
    var image:UIImage?
    var name:String?
    var long:CLLocationDegrees?
    var lat:CLLocationDegrees?
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    var mode: String = TravelMode.drive.rawValue
    
    //MARK: - IBOutlets
    @IBOutlet weak var stationName: UILabel!
    @IBOutlet weak var latitudeValue: UILabel!
    @IBOutlet weak var longitudeValue: UILabel!
    @IBOutlet weak var directionBtnOutlet: UIButton!
    @IBOutlet weak var callButtonOutlet: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    
    
    //MARK: - Main functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
        mapSetup()
        buttonSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let camera = GMSCameraPosition.camera(withLatitude: lat!, longitude: long!, zoom: 12.0)
        markOnMap(latitude: lat!, longitude: long!)
        mapView.camera = camera
    }
    
    //MARK: - IBActions
    @IBAction func directionTapped(_ sender: UIButton) {
        guard let arView = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "ARPathViewController") as? ARPathViewController else {
            fatalError("Could'nt init AR View")
        }
        arView.modalPresentationStyle = .fullScreen
        arView.name = ""
        arView.sourceDetail = LocationDetails(lat: currentLocation.coordinate.latitude, lng: currentLocation.coordinate.longitude, name: "")
        arView.destinationDetail = LocationDetails(lat: lat!, lng: long!, name: "")
        arView.mode = mode
        self.present(arView, animated: true, completion: nil)
        
    }
    
    @IBAction func callTapped(_ sender: UIButton) {
    }
    
    
    //MARK: - Functions
    func buttonSetup() {
        callButtonOutlet.layer.masksToBounds = false
        callButtonOutlet.layer.cornerRadius = 6
        
        directionBtnOutlet.layer.masksToBounds = false
        directionBtnOutlet.layer.cornerRadius = 6
    }
    
    func setup() {
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways){
            
            currentLocation = locManager.location
            let location1 = CLLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            let location2 = CLLocation(latitude: lat!, longitude: long!)
            let distance : CLLocationDistance = location2.distance(from: location1)
            distanceLabel.textColor = .black
            distanceLabel.text = "Distance: \(Int(distance/1000)) km"
            
            stationName.text = name!
            latitudeValue.text = "\(lat!)"
            longitudeValue.text = "\(long!)"
        }

    }
    
    func mapSetup(){
        mapView.clear()
        mapView.delegate = self
        do {
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                print("❌ Unable to find style.json")
            }
        } catch {
            print("❌ One or more of the map styles failed to load. \(error)")
        }
    }
}

extension MapDetailViewController: GMSMapViewDelegate{
    func markOnMap(latitude: Double, longitude:Double) {
        let marker = GMSMarker()
        marker.icon = UIImage(named: "Safe")
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = name
        marker.snippet = "Tamil Nadu"
        marker.map = mapView
    }
}
