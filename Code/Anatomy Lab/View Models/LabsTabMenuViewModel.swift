//
//  LabsTabMenuViewModel.swift
//  Anatomy Lab
//
//  Created by Hector Cen on 11/16/16.
//  Copyright © 2016 Hector Cen. All rights reserved.
//

import Foundation
import SwiftyJSON

class LabsTabMenuViewModel: GeneralTabMenuViewModel {
    
    required init(fromViewController viewController: UIViewController) {
        
        super.init()
        
        self.viewController = viewController
        
    }
    
    func getStation(station: Int, inLab lab: Int) -> JSON? {

        guard let data = Utilities.manager.loadData(forLab: lab, station: station) else {
            return nil
        }

        return data
    }
    
    override func stationSelected(tableView: UITableView, indexPath: NSIndexPath, lab: Int, presentIn viewController: UIViewController?) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let generalStationNavigationVC = storyboard.instantiateViewControllerWithIdentifier("generalStationNavigationViewController") as? UINavigationController,
            let generalStationVC = generalStationNavigationVC.childViewControllers.first as? GeneralStationViewController,
            let validStationInfo = getStation(indexPath.row, inLab: lab) else {
                return
        }
        
        let generalStationViewModel = GeneralStationViewModel(forStation: validStationInfo)
        generalStationVC.generalStationViewModel = generalStationViewModel
        
        Utilities.manager.switchDetailViewController(withViewController: generalStationNavigationVC) { selectedViewController in
            viewController?.dismissViewControllerAnimated(true, completion: {
                selectedViewController?.performSelector((selectedViewController?.displayModeButtonItem().action)!)
            })
        }
    }

}

//MARK: Private API
private extension LabsTabMenuViewModel {
    
    
    
}
