//
//  LabTerminologyDelegateDatasource.swift
//  Anatomy Lab
//
//  Created by Hector Cen on 10/8/16.
//  Copyright © 2016 Hector Cen. All rights reserved.
//

import UIKit
import SwiftyJSON

final class LabTerminologyDelegateDatasource: NSObject {
    
    var terms = [(term: String, subterms: [JSON])]()
    
    typealias CellSelectionHandler = (JSON) -> Void
    var cellSelectionHandler: CellSelectionHandler?
    
}

//MARK: UITableViewDataSource
extension LabTerminologyDelegateDatasource: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return terms.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("terminologyCell", forIndexPath: indexPath)
        
        if let subterm = terms[indexPath.section].subterms[indexPath.row].dictionaryObject {
            cell.textLabel?.text = subterm.first?.0
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return terms[section].term
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return terms[section].subterms.count
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
}

//MARK: UITableViewDelegate
extension LabTerminologyDelegateDatasource: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let selectedTerm = terms[indexPath.section].subterms[indexPath.row]
        cellSelectionHandler?(selectedTerm)
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}