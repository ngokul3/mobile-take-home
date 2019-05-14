//
//  MapViewController.swift
//  MapRoute
//
//  Created by Gokul K Narasimhan on 5/9/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var txtFromField: UITextField!
    @IBOutlet weak var txtToField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    private var polylines: [MKPolyline]?
    private static var modelObserver: NSObjectProtocol?
    private var airportArray: [Airport]?
    
    @IBOutlet weak var searchBarView: UIView!
    private let model = ModelManager.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        MapViewController.modelObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Notifications.ResourcesArrived), object: nil, queue: OperationQueue.main) {
            [weak self] (notification: Notification) in
            
            if let s = self {
                let info2 = notification.userInfo?[Notifications.Airport]
                s.airportArray = info2 as? [Airport]
             }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        guard let identifier = segue.identifier else{
            preconditionFailure("No segue identifier")
        }
        
        switch identifier{
        case "FromTextFieldSegue":
            if let vc = segue.destination as? AirportLocationViewController{
                vc.model = self.model
                vc.doneDetailVC = {[weak self](txt: String?) in
                    self?.txtFromField.text = txt
                }
            }
        case "ToTextFieldSegue" :
            if let vc = segue.destination as? AirportLocationViewController{
                vc.model = self.model
                vc.doneDetailVC = {[weak self](txt: String?) in
                    self?.txtToField.text = txt
                }
            }
            default: break
        }
        
    }
}


extension MapViewController{
    @IBAction func btnFindRouteOnClick(_ sender: UIButton) {
        guard let fromAirport = self.txtFromField.text,
            let toAirport = self.txtToField.text,
                self.txtFromField.text?.count ?? 0 > 0,
                self.txtToField.text?.count ?? 0 > 0 else{
                alertUser = "Please enter both From and To Airport Code. You can search for the code."
                return
        }
        
        if(self.airportArray?.filter({$0.codeIATA?.lowercased() == fromAirport.lowercased()}).count == 0){
            alertUser = "From Airport code is not available"
            return
        }
        
        if(self.airportArray?.filter({$0.codeIATA?.lowercased() == toAirport.lowercased()}).count == 0){
            alertUser = "To Airport code is not available"
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
            let alert = UIAlertController(title: "Information", message: newValue, preferredStyle: .alert)
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
                let shortPath = path.nodeArray.reversed().compactMap({ $0}).map({$0.key.uppercased()})
                alertUser = "Best path found: \(shortPath)"
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
        
        for i in (0..<path.nodeArray.count).reversed(){
            
            if(i-1 < 0){
                break
            }
            
            guard let sourceLatitude = path.nodeArray[safe: i]?.latitude,
                let sourceLongitude = path.nodeArray[safe: i]?.longitude,
                let destinationLatitude = path.nodeArray[safe: i - 1]?.latitude,
                let destinationLongitude = path.nodeArray[safe: i - 1]?.longitude
                else{
                    alertUser = "Coordinate information was not fetched right. Please try again."
                    return
            }
            let sourceLocation = CLLocationCoordinate2D(latitude: sourceLatitude, longitude: sourceLongitude)
            let destinationLocation = CLLocationCoordinate2D(latitude: destinationLatitude, longitude: destinationLongitude)
            
           
            let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
            let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
            
            let sourceAnnotation = MKPointAnnotation()
            sourceAnnotation.title = path.nodeArray[safe: i]?.key.uppercased()
            
            if let location = sourcePlacemark.location {
                sourceAnnotation.coordinate = location.coordinate
            }
            
            let destinationAnnotation = MKPointAnnotation()
            destinationAnnotation.title = path.nodeArray[safe: i-1]?.key.uppercased()
            
            if let location = destinationPlacemark.location {
                destinationAnnotation.coordinate = location.coordinate
            }
            self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
            
            var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
            
            points.append(sourceAnnotation.coordinate)
            points.append(destinationAnnotation.coordinate)

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
