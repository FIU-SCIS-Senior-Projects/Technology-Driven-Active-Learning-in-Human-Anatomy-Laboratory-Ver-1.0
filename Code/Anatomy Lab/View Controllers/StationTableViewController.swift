//
//  StationTableViewController.swift
//  Anatomy Lab
//
//  Created by Darian Mendez on 9/20/16.
//  Modified by Héctor Cen on 9/23/16.
//  Copyright © 2016 Hector Cen. All rights reserved.
//

import UIKit
import SwiftyJSON

class StationTableViewController: UITableViewController {
    
    var stationCellSelectionHandler: StationCellSelectionHandler?
    var stationCellDeselectionHandler: StationCellDeselectionHandler?

    var stationmenuItems = [MainMenuItem]()
    private var stationmainMenuItemsManager: MenuItemsManager?
    
    var selectedStations: [[Int]]?
    
    var labSelected: Int?
    
    @IBOutlet weak var closeButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupDataSource()
        setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: Private API
private extension StationTableViewController {
    
    
    @IBAction func dismiss(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setupViews(){
        
        closeButton.title = String.localizedStringWithFormat("Close")
        
        navigationItem.title = String.localizedStringWithFormat("Stations")
        tableView.scrollEnabled = false
        tableView.allowsMultipleSelection = true
    }
    
    func setupDataSource(){
        stationmainMenuItemsManager = MenuItemsManager(forType: .Station)
        stationmainMenuItemsManager?.itemsHandler = { [weak self] items, error in
            
            guard error == nil else {
                print("error: \(error)")
                print("error loading stations")
                return
            }
            
            guard let _items = items else{
                print("invalid stations information")
                return
            }
            
            self?.stationmenuItems = _items as! [MainMenuItem]
        }
        stationmainMenuItemsManager?.allItems(forLab: labSelected)
    }
    
}
//MARK: - UITableViewDataSource
extension StationTableViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationmenuItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
                
        let cell = tableView.dequeueReusableCellWithIdentifier("stationCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = stationmenuItems[indexPath.row].title
        cell.detailTextLabel?.text = stationmenuItems[indexPath.row].subtitle
        cell.selectionStyle = .None
        
        if let validSelectedStations = selectedStations {
            cell.accessoryType = validSelectedStations[labSelected ?? 0][indexPath.row] == 1 ? .Checkmark : .None
        }
        
        return cell
    }
    
}
//MARK: - UITableViewDelegate
extension StationTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        stationCellSelectionHandler?(tableView, indexPath)
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        stationCellDeselectionHandler?(tableView, labSelected ?? 0, indexPath)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}


 
