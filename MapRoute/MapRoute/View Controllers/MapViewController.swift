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
    
    @IBOutlet weak var mapView: MKMapView!
    var polylines: [MKPolyline]?
    
    
    private static var modelObserver: NSObjectProtocol?
    private var airportArray: [Airport]?
    private var graph: Graph?
    var fromResultSearchController: UISearchController!
    var toResultSearchController: UISearchController!
    
    @IBOutlet weak var searchBarView: UIView!
    let locationManager = CLLocationManager()
    private var model = ModelManager.getInstance()
    //var airportLocationSearchController : AirportLocationViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
//        self.airportLocationSearchController = storyboard?.instantiateViewController(withIdentifier: "AirportLocationViewController") as? AirportLocationViewController
//
//        airportLocationSearchController?.model = self.model
        
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
//                let info0 = notification.userInfo?[Notifications.Route]
//                s.routeArray = info0 as? [Route]
//
//                let info1 = notification.userInfo?[Notifications.Airline]
//                s.airlineArray = info1 as? [Airline]

                let info2 = notification.userInfo?[Notifications.Airport]
                s.airportArray = info2 as? [Airport]
                
                s.graph = s.model.getGraph()
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


extension MapViewController{
    @IBAction func btnFindRouteOnClick(_ sender: UIButton) {
        guard let fromAirport = self.txtFromField.text,
            let toAirport = self.txtToField.text else{
                alertUser = "Airport information is not correct"
                return
        }
        if(self.airportArray?.filter({$0.codeIATA == fromAirport}).count == 0){
            alertUser = "From Airport is not correct"
            return
        }
        
        if(self.airportArray?.filter({$0.codeIATA == toAirport}).count == 0){
            alertUser = "To Airport is not correct"
            return
        }
        
        if let overlays = self.polylines{
            mapView.removeOverlays(overlays)
        }
        
        self.mapView.removeAnnotations(mapView.annotations)
        
        
        self.getRoute(origin: fromAirport, destination: toAirport)
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

extension MapViewController{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        
        renderer.strokeColor = UIColor(red: 17.0/255.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1)
        
        renderer.lineWidth = 5.0
        
        return renderer
    }
    
    func getRoute(origin: String, destination: String){
        if let g = model.getGraph(){
            let originNode = g.retrieveNode(key: origin) ?? Node()
            let destinationNode = g.retrieveNode(key: destination) ?? Node()
            let pathFinder = PathFinder()
            if let path = pathFinder.shortestPath(source: originNode, destination: destinationNode){
                self.displayRoute(path: path)
            }else{
                alertUser = "No Route found"
            }
        }else{
            alertUser = "Resources are still loading up. Please try again after few mins!!"
        }
    }
    
    func displayRoute(path: Path){
        self.polylines = [MKPolyline]()
        for i in 0..<path.nodeArray.count{
            
            if(i+1 == path.nodeArray.count){
                break
            }
            
            guard let sourceLatitude = path.nodeArray[safe: i]?.latitude,
                let sourceLongitude = path.nodeArray[safe: i]?.longitude,
                let destinationLatitude = path.nodeArray[safe: i + 1]?.latitude,
                let destinationLongitude = path.nodeArray[safe: i + 1]?.longitude
                else{
                    alertUser = "Coordinate information was not fetched right. Please try again."
                    return
            }
            let sourceLocation = CLLocationCoordinate2D(latitude: sourceLatitude, longitude: sourceLongitude)
            let destinationLocation = CLLocationCoordinate2D(latitude: destinationLatitude, longitude: destinationLongitude)
            
           
            let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
            let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
            
            let sourceAnnotation = MKPointAnnotation()
            sourceAnnotation.title = path.nodeArray[safe: i]?.key
            
            if let location = sourcePlacemark.location {
                sourceAnnotation.coordinate = location.coordinate
            }
            
            let destinationAnnotation = MKPointAnnotation()
            destinationAnnotation.title = path.nodeArray[safe: i+1]?.key
            
            if let location = destinationPlacemark.location {
                destinationAnnotation.coordinate = location.coordinate
            }
            self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
            
            var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
            
            for annotation in self.mapView.annotations {
                points.append(annotation.coordinate)
            }
            let polyline = MKPolyline(coordinates: points, count: points.count)
            mapView.addOverlay(polyline)
            self.polylines?.append(polyline)
        }
    }
}

extension MapViewController: MKMapViewDelegate{
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        return nil
    }
}
