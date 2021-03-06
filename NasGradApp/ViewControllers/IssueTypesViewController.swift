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
    
    static var regionsData = [Type]()
    static var cityServicesData = [Type]()
    static var typesData = [Type]()
    static var cityServiceTypesData = [Type]()
    
    public var region:String = ""
    
    struct Segment {
        var name: String = ""
        var types = [String]()
        
        var serviceData:Type? = nil
        var issuesData:[Type] = [Type]()
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
        
         updateTitle()
    }
    
    private func renderData() {
        // prepare all the data needed with current region
        tableData.removeAll()
        
        region = "Novi Sad"
        
        // find region data form region
        var selRegionData:Type? = nil
        for regionData in IssueTypesViewController.regionsData {
            if regionData.city == region {
                selRegionData = regionData
                break
            }
        }
        
        
        if selRegionData != nil {
            
            // filter services
            //var selServicesData = [Type]()
              for cityServiceData in IssueTypesViewController.cityServicesData {
                if cityServiceData.region == selRegionData?.id {
                    //selServicesData.append(cityServiceData)
                     var seg:Segment = Segment()
                    seg.name = cityServiceData.name!
                    seg.serviceData = cityServiceData
                     tableData.append(seg)
                }
            }
            
            if tableData.count > 0 {
                // get all issues for all city services gathered
                for i in 0..<tableData.count {
                   
                    for cityServiceTypeData in IssueTypesViewController.cityServiceTypesData {
                        if tableData[i].serviceData?.id == cityServiceTypeData.cityService {
                            tableData[i].issuesData.append(cityServiceTypeData)
                        }
                    }
                }
                
                // now transfer gathered data to strings
                 for i in 0..<tableData.count {
                    for issueData in tableData[i].issuesData {
                        tableData[i].types.append("?")
                        
                        for typeData in IssueTypesViewController.typesData {
                            if issueData.type == typeData.id  {
                                if typeData.name != nil {
                                    tableData[i].types[tableData[i].types.count-1] = typeData.name!
                                    break;
                                }
                            }
                        }
                    }
                }
            }
            
        }
        /*
        var seg:Segment = Segment()
        seg.name = "Seg 1"
        seg.types.append("type1")
        tableData.append(seg)
        */
        
        self.tableView.reloadData()
    }
    
    private func hasData() -> Bool {
        if IssueTypesViewController.regionsData.count > 0 {
            if IssueTypesViewController.cityServicesData.count > 0 {
                if IssueTypesViewController.typesData.count > 0 {
                    if IssueTypesViewController.cityServiceTypesData.count > 0 {
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
                IssueTypesViewController.regionsData.removeAll()
                IssueTypesViewController.regionsData.append(contentsOf: typesData!)
                // DDLogVerbose(String(describing: typesData))
                self.checkFetchCompletition(withCompletionHandler: withCompletionHandler)
            })
            
            
            self.networkEngine.performNetworkRequest(forURLRequest: getCityServicesRequest, responseType: [Type].self, completionHandler: { (typesData, response, error) in
                IssueTypesViewController.cityServicesData.removeAll()
                IssueTypesViewController.cityServicesData.append(contentsOf: typesData!)
                // DDLogVerbose(String(describing: typesData))
                self.checkFetchCompletition(withCompletionHandler: withCompletionHandler)
            })
            
            self.networkEngine.performNetworkRequest(forURLRequest: getTypesRequest, responseType: [Type].self, completionHandler: { (typesData, response, error) in
                IssueTypesViewController.typesData.removeAll()
                IssueTypesViewController.typesData.append(contentsOf: typesData!)
                // DDLogVerbose(String(describing: typesData))
                self.checkFetchCompletition(withCompletionHandler: withCompletionHandler)
                
            })
            
            self.networkEngine.performNetworkRequest(forURLRequest: getCityServiceTypesRequest, responseType: [Type].self, completionHandler: { (typesData, response, error) in
                IssueTypesViewController.cityServiceTypesData.removeAll()
                IssueTypesViewController.cityServiceTypesData.append(contentsOf: typesData!)
                // DDLogVerbose(String(describing: typesData))
                self.checkFetchCompletition(withCompletionHandler: withCompletionHandler)
                
            })
        }
    }
    
    @IBAction func clearSelection() {
      selected.removeAll()
        self.tableView.reloadData()
         updateTitle()
    }
    
    func updateTitle() {
        if selected.count == 0 {
            self.title = "Izaberite probleme"
        } else {
            self.title = "Izaberano problema: \(selected.count)"
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
             updateTitle()
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
