//
//  MapViewController.swift
//  iRis
//
//  Created by Sarvad shetty on 12/14/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import CoreMotion
import Lottie
import JGProgressHUD

class MapViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var greetLabel: UILabel!
    
    //MARK: - Variables
    var location:CLLocationCoordinate2D!
    var locationManager = CLLocationManager()
    private let dataProvider = GoogleDataProvider()
    private let searchRadius: Double = 1000000
    var searchedTypes = ["police"]
    var flag = 0
    var motionManager = CMMotionManager()
    var currenLocManager:CLLocationManager = CLLocationManager()
    let hud = JGProgressHUD(style: .dark)

    //MARK: - Main functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initializeTheLocationManager()
        mapViewDelegateSetup()
        self.mapView.isMyLocationEnabled = true
        hud.show(in: self.view)
        initialSetup()
        
    }
    
    //MARK: - Functions
    func initialSetup() {
        greetLabel.text = "Hi!, \(User.currentUser()!.name!)"
    }

}

//MARK: - Extensions
extension MapViewController: CLLocationManagerDelegate {
    
    func initializeTheLocationManager()
    {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.setMinZoom(4.6, maxZoom: 50)
        
    }
    
    func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?) {
        if toLocation != nil {
            mapView.camera = GMSCameraPosition.camera(withTarget: toLocation!, zoom: 16)
        }
    }
    
    func locationManager(_ manager: CLLocationManager,didUpdateLocations locations: [CLLocation]) {
        let location = locationManager.location?.coordinate
        if(flag == 0)
        {
            cameraMoveToLocation(toLocation: location)
            flag = flag+1
            
        }
        fetchNearbyPlaces(coordinate: location!)
    }
    
    private func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
        dataProvider.fetchPlacesNearCoordinate(coordinate, radius:searchRadius, types: searchedTypes) { places in
            
            guard places.count > 0 else {
                return
                
            }
            self.hud.dismiss(animated: true)
            places.forEach {
                let marker = PlaceMarker(place: $0)
                marker.map = self.mapView
            }
        }
    }
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
           let geocoder = GMSGeocoder()
           geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
               guard let address = response?.firstResult(), let lines = address.lines else {
                   return
               }
              print("\(lines.joined(separator: "\n"))")

           }
       }
}

extension MapViewController: GMSMapViewDelegate {
    
    func mapViewDelegateSetup(){
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
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if (gesture) {
            mapView.selectedMarker = nil
        }
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        guard let placeMarker = marker as? PlaceMarker else {
            return nil
        }
                
        guard let mdetail = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MapDetailViewController") as? MapDetailViewController else {
            fatalError("couldnt mssgs")
        }

        if let photo = placeMarker.place.photo {
            mdetail.image = photo
        }else{
            mdetail.image = nil
        }

        let name = placeMarker.place.name
        mdetail.name = name
        mdetail.long = placeMarker.place.coordinate.longitude
        mdetail.lat = placeMarker.place.coordinate.latitude

        print("coordinate: \(placeMarker.place.coordinate)")
        self.present(mdetail, animated: true, completion: nil)

        return UIView()
    }
    
}
