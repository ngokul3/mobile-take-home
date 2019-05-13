//
//  AppDelegate.swift
//  MapRoute
//
//  Created by Gokul K Narasimhan on 5/9/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import UIKit
var AppDel: AppDelegate {
    get {
        return UIApplication.shared.delegate as! AppDelegate
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
//    var netModel: NetworkProtocol{
//        return Network.getInstance()
//    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }



}

