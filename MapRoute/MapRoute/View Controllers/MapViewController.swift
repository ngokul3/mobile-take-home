//
//  MapViewController.swift
//  MapRoute
//
//  Created by Gokula K Narasimhan on 5/9/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import UIKit
import MapKit
let handleTextChangeNotification = "handleTextChangeNotification"
class MapViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var txtFromField: UITextField!
    
    @IBOutlet weak var txtToField: UITextField!
    
//    @IBAction func btnFromTextClick(_ sender: UIButton) {
//        if let vc = airportLocationSearchController{
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//    }
    
    @IBAction func btnFindRouteOnClick(_ sender: UIButton) {
        if(self.airportArray?.filter({$0.codeIATA == self.txtFromField.text}).count == 0){
            alertUser = "From Airport is not correct"
            return
        }
        
        if(self.airportArray?.filter({$0.codeIATA == self.txtToField.text}).count == 0){
            alertUser = "To Airport is not correct"
            return
        }
        
    }
    
    private static var modelObserver: NSObjectProtocol?
    private var routeArray: [Route]?
    private var airlineArray: [Airline]?
    private var airportArray: [Airport]?
    var fromResultSearchController: UISearchController!
    var toResultSearchController: UISearchController!
    
    @IBOutlet weak var searchBarView: UIView!
    let locationManager = CLLocationManager()
    private var model = ModelManager.getInstance()
    //var airportLocationSearchController : AirportLocationViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = model.loadResources()
//        self.airportLocationSearchController = storyboard?.instantiateViewController(withIdentifier: "AirportLocationViewController") as? AirportLocationViewController
//
//        airportLocationSearchController?.model = self.model
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //txtFromField.delegate = self
//        txtFromField.addTarget(self, action: #selector(UITextFieldDelegate.textFieldDidBeginEditing(_:)), for: UIControl.Event.editingDidBegin)
        
        
//        fromResultSearchController =  UISearchController(searchResultsController: airportLocationSearchController)
//        toResultSearchController = UISearchController(searchResultsController: airportLocationSearchController)
//        fromResultSearchController.searchResultsUpdater = airportLocationSearchController
//        toResultSearchController.searchResultsUpdater = airportLocationSearchController
//        let fromLocationsearchBar = fromResultSearchController!.searchBar
//        let toLocationSearchBar = toResultSearchController!.searchBar
//        fromLocationsearchBar.placeholder = "from location"
//        toLocationSearchBar.placeholder = "to location"
//        fromLocationsearchBar.frame = CGRect(x: 0,y: 10,width: self.searchBarView.frame.width, height: self.searchBarView.frame.height * 0.40)
//        toLocationSearchBar.frame = CGRect(x: 0,y: 10, width: self.searchBarView.frame.width, height: self.searchBarView.frame.height * 0.40)
        //self.searchBarView.addSubview(fromLocationsearchBar)
     //   self.searchBarView.addSubview(toLocationSearchBar)
//        searchBar.sizeToFit()
//        searchBar2.sizeToFit()
//        searchBar.placeholder = "Search for places"
//        searchBar2.placeholder = "Search for places"
//        navigationItem.titleView = fromResultSearchController?.searchBar
//        fromResultSearchController.hidesNavigationBarDuringPresentation = false
//        fromResultSearchController.dimsBackgroundDuringPresentation = true
       // definesPresentationContext = true
        
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let vc = segue.destination as? AirportLocationViewController{
            vc.model = self.model
        }
    }
//    @IBAction func txtFromFieldTouchDown(_ sender: UITextField) {
//        if let vc = airportLocationSearchController{
//        self.navigationController?.pushViewController(vc, animated: true)
//        }
//    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//
////        let storyboard = UIStoryboard(name: "Main", bundle: nil)
////        let airportLocationSearchController = storyboard.instantiateViewController(withIdentifier: "AirportLocationViewController") as! AirportLocationViewController
////        addChild(airportLocationSearchController)
////        airportLocationSearchController.view.frame = self.view.bounds
////        self.view.addSubview(airportLocationSearchController.view)
////        airportLocationSearchController.didMove(toParent: self)
////
////
////        NotificationCenter.default.post(name: NSNotification.Name(rawValue: handleTextChangeNotification), object: nil, userInfo: ["text":textField])
//    }
    
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

extension MapViewController: UITableViewDelegate, UITableViewDataSource{
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //cell.textLabel?.text = model.filteredAirports[indexPath.row].codeIATA
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
}

extension MapViewController{
    var alertUser :  String{
        get{
            preconditionFailure("You cannot read from this object")
        }
        set{
            let alert = UIAlertController(title: "Attention", message: newValue, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
