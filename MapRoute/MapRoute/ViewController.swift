//
//  ViewController.swift
//  MapRoute
//
//  Created by Gokula K Narasimhan on 5/9/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private static var modelObserver: NSObjectProtocol?
    private var routeArray: [Route]?
    private var airlineArray: [Airline]?
    private var airportArray: [Airport]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var obj = ModelManager()
        obj.loadResources()
        
        ViewController.modelObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Notifications.ResourcesArrived), object: nil, queue: OperationQueue.main) {
            [weak self] (notification: Notification) in
            
            if let s = self {
                let info0 = notification.userInfo?[Notifications.Route]
                s.routeArray = info0 as? [Route]
                
                let info1 = notification.userInfo?[Notifications.Airline]
                s.airlineArray = info0 as? [Airline]
                
                let info2 = notification.userInfo?[Notifications.Airport]
                s.airportArray = info0 as? [Airport]
            }
        }
    }


}

