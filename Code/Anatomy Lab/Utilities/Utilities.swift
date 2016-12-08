//
//  Utilities.swift
//  Anatomy Lab
//
//  Created by Hector Cen on 9/12/16.
//  Copyright © 2016 Hector Cen. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

final class Utilities {
    
    /// The shared manager for the Singleton instance
    static let manager = Utilities()
    
    /// A key defined to be the same as the labs root element in the data
    private static let labsKey = "labs"
    /// A key defined to be the same as the stations elements in the labs objects
    private static let stationsKey = "stations"
    /// A key defined to be the same as the metadata elements for either labs or stations
    private static let metadataKey = "metadata"
    
    typealias LogoutCompletionHandler = () -> Void
    
    /**
     Loads the data required for the app to work. Data is statically stored in a JSON file in the application bundle.
     
     - parameter lab:     An Int? indicating the lab to return the data for.
     - parameter station: An Int? indicating the station to return the data for.
     
     - returns: An optional JSON (SwiftyJSON) struct
     */
    func loadData(forLab lab: Int? = nil, station: Int? = nil) -> JSON? {
        guard let path = NSBundle.mainBundle().pathForResource("lab", ofType: "json"),
            let data = NSData(contentsOfFile: path) else {
            print("path data nil")
            return nil
        }
        if let validLab = lab, validStation = station  {
            return JSON(data: data)[Utilities.labsKey][validLab][Utilities.stationsKey][validStation]
        }
        if let validLab = lab {
            return JSON(data: data)[Utilities.labsKey][validLab]
        }
        return JSON(data: data)[Utilities.labsKey]
    }
    
    /**
     Loads metadata from the passed JSON data
     
     - parameter data: A root element for a lab or station to get the metadata for.
     
     - returns: A JSON? containing the metadata
     */
    func loadMetadata(fromData data: JSON) -> JSON? {
        return data[Utilities.metadataKey][0]
    }
    
    /**
     Loads the station objects from the passed JSON data (labs)
     
     - parameter data: A root elements for Labs to seek stations
     
     - returns: A JSON? with the stations found for such Lab.
     */
    func loadStations(fromData data: JSON) -> JSON? {
        return data[Utilities.stationsKey]
    }
    
    /**
     Change the detail view controller in the split view controller holding the current detail view
     
     - parameter splitViewController: The UISplitViewController that we wish to modify.
     - parameter viewController:      The view controller we want to add.
     - parameter completionHandler:   A callback to execute back in the calling class.
     */
    func switchDetailViewController(withViewController viewController: UIViewController,
                                                       completionHandler: (GeneralSplitViewController?) -> ()) {
        
        guard let mainTabBarViewController = UIApplication.sharedApplication().keyWindow?.rootViewController as? MainTabViewController,
            let splitViewController = mainTabBarViewController.viewControllers?[mainTabBarViewController.selectedIndex] as? GeneralSplitViewController else {
                return
        }
        
        splitViewController.viewControllers.removeLast()
        splitViewController.viewControllers.append(viewController)
        completionHandler(splitViewController)
    }
    
    /**
     Deletes all the users from the device's local database
     
     - parameter completionHandler: A completion handler that is called after deleting the currently logged in user email from NSUserDefaults.
     */
    func logout(completionHandler: LogoutCompletionHandler) {
        let standardDefaults = NSUserDefaults.standardUserDefaults()
        standardDefaults.setValue(nil, forKey: "currentUserEmail")
        standardDefaults.synchronize()
        completionHandler()
    }
    
    /**
     Instantiates a Login View Controller, to be presented modally, from the Storyboard and returns it through a completion handler.
     
     - parameter completionHandler: A completion handler to return the newly instantiated LoginViewController.
     */
    func loginViewController(completionHandler: (viewController: UIViewController) -> ()) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("LoginViewController")
        vc.modalPresentationStyle = UIModalPresentationStyle.FullScreen
        vc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        completionHandler(viewController: vc)
    }
    
    /**
     Returns the instance of the currently set MainTabViewController
     
     - returns: The instance of the MainTabViewController
     */
    func mainTabViewController() -> MainTabViewController? {
        return UIApplication.sharedApplication().keyWindow?.rootViewController as? MainTabViewController
    }
    
}
