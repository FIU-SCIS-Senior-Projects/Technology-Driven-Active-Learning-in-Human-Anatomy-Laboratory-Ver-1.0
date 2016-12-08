//
//  TerminologyTabMenuViewModel.swift
//  Anatomy Lab
//
//  Created by Hector Cen on 11/16/16.
//  Copyright © 2016 Hector Cen. All rights reserved.
//

import Foundation

class TerminologyTabMenuViewModel: GeneralTabMenuViewModel {
        
    required init(fromViewController viewController: UIViewController) {
        
        super.init()
        
        self.viewController = viewController
        
    }
    
    override func stationSelected(tableView: UITableView, indexPath: NSIndexPath, lab: Int, presentIn viewController: UIViewController?) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) where cell.selected {
            cell.accessoryType = .Checkmark
        }
        
        self.selectedStations[lab][indexPath.row] = 1
    }

}

//MARK: Private API
private extension TerminologyTabMenuViewModel {
    
    
    
}