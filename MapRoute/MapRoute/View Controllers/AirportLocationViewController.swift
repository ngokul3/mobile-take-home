//
//  AirportLocationViewController.swift
//  MapRoute
//
//  Created by Gokula K Narasimhan on 5/12/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import UIKit

class AirportLocationViewController: UITableViewController {

    //private var airportArray: [Airport]?
    
    var resultSearchController: UISearchController!
    var model : ModelManagerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultSearchController =  UISearchController(searchResultsController: self)
        
        resultSearchController.searchResultsUpdater = self
        let locationsearchBar = resultSearchController!.searchBar
        locationsearchBar.placeholder = "from location"
        locationsearchBar.sizeToFit()
        navigationItem.titleView = resultSearchController.searchBar
        
         resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = false
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue:   Notifications.AirportFiltered), object: nil, queue: OperationQueue.main) {
            
            [weak self] (notification: Notification) in
            if let s = self {
                s.updateUI()
            }
        }
      }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        self.definesPresentationContext = true
//        
//    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        self.definesPresentationContext = false
//
//    }
}

extension AirportLocationViewController{
    func updateUI(){
        self.tableView.reloadData()
    }
}

extension AirportLocationViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let searchBarText = searchController.searchBar.text ?? ""
        if(model?.currentFilter != searchBarText && searchBarText.count != 0){
            model?.currentFilter = searchBarText
        }
    }
}

extension AirportLocationViewController{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.filteredAirports.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model?.filteredAirports[indexPath.row].codeIATA
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
}

