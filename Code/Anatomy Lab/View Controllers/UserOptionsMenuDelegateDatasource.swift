//
//  UserOptionsMenuDelegateDatasource.swift
//  Anatomy Lab
//
//  Created by Hector Cen on 11/24/16.
//  Copyright © 2016 Hector Cen. All rights reserved.
//

import UIKit

enum MenuOptionType: Int {
    
    case StudentInformation = 0
    case CourseInformation = 1
    case ProgressInformation = 2
    case GradingStatistics = 3
    case AppInformation = 4
    case SignOut = 5
    
    
    func title() -> String {
        switch self {
        case .StudentInformation:
            return NSLocalizedString("Student Information", comment: "")
        case .CourseInformation:
            return NSLocalizedString("Course Information", comment: "")
        case .ProgressInformation:
            return NSLocalizedString("Progress Information", comment: "")
        case .GradingStatistics:
            return NSLocalizedString("Grading Statistics", comment: "")
        case .AppInformation:
            return NSLocalizedString("Settings", comment: "")
        case .SignOut:
            return NSLocalizedString("Sign out", comment: "")
        }
    }
    
}

class UserOptionsMenuDelegateDatasource: NSObject {
    
    private var menuOptions: [MenuOptionType] = [.StudentInformation,
                                                 .CourseInformation,
                                                 .ProgressInformation,
                                                 .GradingStatistics,
                                                 .AppInformation,
                                                 .SignOut]
    
    typealias CellSelectionHandler = (MenuOptionType) -> Void
    var cellSelectionHandler: CellSelectionHandler?

}

//MARK: Private API
private extension UserOptionsMenuDelegateDatasource {
    
    
    
}

//MARK: UITableViewDelegate
extension UserOptionsMenuDelegateDatasource: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        guard let validMenuOption = MenuOptionType(rawValue: indexPath.row) else {
            print("Non-supported menu option selected.")
            return
        }
        
        cellSelectionHandler?(validMenuOption)
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}

//MARK: UITableViewDatasource
extension UserOptionsMenuDelegateDatasource: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("userOptionCell", forIndexPath: indexPath)
        
        guard let validMenuOption = MenuOptionType(rawValue: indexPath.row) else {
            assertionFailure("Non-valid menu option")
            return cell
        }
        
        cell.textLabel?.text = validMenuOption.title()
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
}