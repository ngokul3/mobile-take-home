//
//  MapViewController.swift
//  MapRoute
//
//  Created by Gokula K Narasimhan on 5/9/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    private static var modelObserver: NSObjectProtocol?
    private var routeArray: [Route]?
    private var airlineArray: [Airline]?
    private var airportArray: [Airport]?
    
    var resultSearchController: UISearchController!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //locationManager.requestWhenInUseAuthorization()
       // locationManager.requestLocation()
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "AirportLocationViewController") as! AirportLocationViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        MapViewController.modelObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Notifications.ResourcesArrived), object: nil, queue: OperationQueue.main) {
            [weak self] (notification: Notification) in
            
            if let s = self {
                let info0 = notification.userInfo?[Notifications.Route]
                s.routeArray = info0 as? [Route]
                
                let info1 = notification.userInfo?[Notifications.Airline]
                s.airlineArray = info1 as? [Airline]
                
                let info2 = notification.userInfo?[Notifications.Airport]
                s.airportArray = info2 as? [Airport]
            }
        }
    }


}

extension MapViewController: CLLocationManagerDelegate{
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
       
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.first else { return }
//        let span = MKCoordinateSpanMake(0.05, 0.05)
//        let region = MKCoordinateRegion(center: location.coordinate, span: span)
//        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error:: \(error)")
    }
}

