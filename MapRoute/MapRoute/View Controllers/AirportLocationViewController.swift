//
//  AirportLocationViewController.swift
//  MapRoute
//
//  Created by Gokul K Narasimhan on 5/12/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import UIKit

class AirportLocationViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func btnDoneClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var resultSearchController: UISearchController!
    var model : ModelManagerProtocol?
    var doneDetailVC: ((String?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.becomeFirstResponder()
        self.model?.currentFilter = ""
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue:   Notifications.AirportFiltered), object: nil, queue: OperationQueue.main) {
            
            [weak self] (notification: Notification) in
            if let s = self {
                s.updateUI()
            }
        }
      }
}

extension AirportLocationViewController{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(model?.currentFilter != searchText){
            model?.currentFilter = searchText
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        model?.currentFilter = ""
        searchBar.resignFirstResponder()
    }
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.filteredAirports.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let airportName = model?.filteredAirports[indexPath.row].name ?? ""
        let airportCode = model?.filteredAirports[indexPath.row].codeIATA ?? ""
        let displayString =  airportCode + " - " + airportName
        cell.textLabel?.text = displayString
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        let airportCode = model?.filteredAirports[indexPath.row].codeIATA
        doneDetailVC?(airportCode)
        self.dismiss(animated: true, completion: nil)
    }
}

