//
//  IssueTypesViewController.swift
//  NasGradApp
//
//  Created by Sierra on 4/25/19.
//  Copyright © 2019 NasGrad. All rights reserved.
//

import UIKit
import CocoaLumberjack

class IssueTypesViewController: UITableViewController {
    
    let networkEngine: NetworkEngineProtocol = container.resolve(NetworkEngineProtocol.self)!
    let networkRequestEngine: NetworkRequestEngineProtocol = container.resolve(NetworkRequestEngineProtocol.self)!
    
    var selected = [IndexPath]()
    
    var regionsData = [Type]()
    var cityServicesData = [Type]()
    var typesData = [Type]()
    var cityServiceTypesData = [Type]()
    
    public var region:String = ""
    
    struct Segment {
        var name: String = ""
        var types = [String]()
    }
    
    var tableData = [Segment]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        selected.removeAll()
        
        print("IssueTypesViewController - region \(region)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(Constants.API.apiUrl)")
        
        if !hasData() {
            fetchData(withCompletionHandler: {
                self.renderData()
            })
        } else {
            renderData()
        }
    }
    
    private func renderData() {
        // prepare all the data needed with current region
        tableData.removeAll()
        
        var seg:Segment = Segment()
        seg.name = "Seg 1"
        seg.types.append("type1")
        tableData.append(seg)
        
        
        self.tableView.reloadData()
    }
    
    private func hasData() -> Bool {
        if regionsData.count > 0 {
            if cityServicesData.count > 0 {
                if typesData.count > 0 {
                    if cityServiceTypesData.count > 0 {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    private func checkFetchCompletition(withCompletionHandler: @escaping () -> Void) {
        if hasData() {
            DispatchQueue.main.async {
                hideLoader {
                    withCompletionHandler()
                }
            }
        }
        
    }
    
    private func fetchData(withCompletionHandler: @escaping () -> Void) {
        let getRegionsRequest = networkRequestEngine.getNewIssueRegions()
        let getCityServicesRequest = networkRequestEngine.getNewIssueCityServices()
        let getTypesRequest = networkRequestEngine.getNewIssueTypes()
        let getCityServiceTypesRequest = networkRequestEngine.getNewIssueCityServiceTypes()
        
        
        showLoader {
            
            self.networkEngine.performNetworkRequest(forURLRequest: getRegionsRequest, responseType: [Type].self, completionHandler: { (typesData, response, error) in
                self.regionsData.removeAll()
                self.regionsData.append(contentsOf: typesData!)
                // DDLogVerbose(String(describing: typesData))
                self.checkFetchCompletition(withCompletionHandler: withCompletionHandler)
            })
            
            
            self.networkEngine.performNetworkRequest(forURLRequest: getCityServicesRequest, responseType: [Type].self, completionHandler: { (typesData, response, error) in
                self.cityServicesData.removeAll()
                self.cityServicesData.append(contentsOf: typesData!)
                // DDLogVerbose(String(describing: typesData))
                self.checkFetchCompletition(withCompletionHandler: withCompletionHandler)
            })
            
            self.networkEngine.performNetworkRequest(forURLRequest: getTypesRequest, responseType: [Type].self, completionHandler: { (typesData, response, error) in
                self.typesData.removeAll()
                self.typesData.append(contentsOf: typesData!)
                // DDLogVerbose(String(describing: typesData))
                self.checkFetchCompletition(withCompletionHandler: withCompletionHandler)
                
                
            })
            
            self.networkEngine.performNetworkRequest(forURLRequest: getCityServiceTypesRequest, responseType: [Type].self, completionHandler: { (typesData, response, error) in
                self.cityServiceTypesData.removeAll()
                self.cityServiceTypesData.append(contentsOf: typesData!)
                // DDLogVerbose(String(describing: typesData))
                self.checkFetchCompletition(withCompletionHandler: withCompletionHandler)
                
                
                
            })
            
            
        }
    }
    
    // MARK: - Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if (cell.accessoryType == .none) {
                cell.accessoryType = .checkmark
                selected.append(indexPath)
            } else {
                cell.accessoryType = .none
                if let index = selected.index(of:indexPath) {
                    selected.remove(at: index)
                }
            }
        }
    }
    
    // MARK: - Datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].types.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableData[section].name
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "IssueTypeCell")
        
        cell.selectionStyle = .none
        
        if (selected.contains(indexPath)) {
            cell.accessoryType = .checkmark
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.bottom)
        } else {
            cell.accessoryType = .none
        }
        
        cell.textLabel?.text = tableData[indexPath.section].types[indexPath.row]
        
        
        return cell
    }
    
}
