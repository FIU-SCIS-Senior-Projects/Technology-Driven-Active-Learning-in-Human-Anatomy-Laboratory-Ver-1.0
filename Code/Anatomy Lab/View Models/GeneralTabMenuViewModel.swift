//
//  GeneralTabMenuViewModel.swift
//  Anatomy Lab
//
//  Created by Hector Cen on 11/16/16.
//  Copyright © 2016 Hector Cen. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias CellSelectionHandler = (UITableView, NSIndexPath) -> Void
typealias CellDeselectionHandler = (UITableView, NSIndexPath) -> Void
typealias StationCellSelectionHandler = (UITableView, NSIndexPath) -> Void
typealias StationCellDeselectionHandler = (UITableView, Int, NSIndexPath) -> Void
typealias StationSelectionChanged = ([[Int]]) -> Void

class GeneralTabMenuViewModel: NSObject {
    
    var cellSelectionHandler: CellSelectionHandler?
    var cellDeselectionHandler: CellSelectionHandler?
    
    var stationCellSelectionHandler: StationCellSelectionHandler?
    var stationCellDeselectionHandler: StationCellDeselectionHandler?
    
    var stationSelectionChanged: StationSelectionChanged?
    
    var selectedLab = 0
    var selectedStations: [[Int]] = [[0, 0, 0, 0, 0, 0],
                                     [0, 0, 0, 0, 0, 0],
                                     [0, 0, 0, 0, 0, 0],
                                     [0, 0, 0, 0, 0, 0],
                                     [0, 0, 0, 0, 0, 0],
                                     [0, 0, 0, 0, 0, 0]]
        {
        didSet {
            stationSelectionChanged?(selectedStations)
        }
        
    }
    
    var viewController: UIViewController?
    
    override init() {
        
        super.init()
        
        self.cellSelectionHandler = { tableView, indexPath in
            self.selectedLab = indexPath.row
            self.showMenu(forLab: indexPath.row, displayIncell: tableView.cellForRowAtIndexPath(indexPath) ?? UITableViewCell(), presentIn: self.viewController)
        }
    }

}

//MARK: - Functions
extension GeneralTabMenuViewModel {
    
    func showMenu(forLab lab: Int, displayIncell cell: UITableViewCell, presentIn viewController: UIViewController?){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let menuNavigationController = storyboard.instantiateViewControllerWithIdentifier("stationNavigationMenuViewController") as? UINavigationController else {
            return
        }
        if let stationMenuViewController = menuNavigationController.childViewControllers.first as? StationTableViewController {
            stationMenuViewController.labSelected = lab
            stationMenuViewController.stationCellSelectionHandler = { [weak self] tableView, indexPath in
                self?.stationSelected(tableView, indexPath: indexPath, lab: lab, presentIn: viewController)
            }
            stationMenuViewController.stationCellDeselectionHandler = self.stationCellDeselectionHandler
            stationMenuViewController.selectedStations = self.selectedStations
        }
        
        menuNavigationController.modalPresentationStyle = UIModalPresentationStyle.Popover
        menuNavigationController.preferredContentSize = CGSizeMake(400, 280)
        viewController?.presentViewController(menuNavigationController, animated: true, completion: nil)
        
        let popoverPresentationController = menuNavigationController.popoverPresentationController
        popoverPresentationController?.sourceView = cell.contentView
        popoverPresentationController?.sourceRect = cell.contentView.frame
        popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.Left
        popoverPresentationController?.delegate = self
    }
    
    func stationSelected(tableView: UITableView, indexPath: NSIndexPath, lab: Int, presentIn viewController: UIViewController?){
        preconditionFailure("This method must be overridden")
    }
    
}

//MARK: - UIPopoverPresentationControllerDelegate
extension GeneralTabMenuViewModel: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .None
    }
    
}
