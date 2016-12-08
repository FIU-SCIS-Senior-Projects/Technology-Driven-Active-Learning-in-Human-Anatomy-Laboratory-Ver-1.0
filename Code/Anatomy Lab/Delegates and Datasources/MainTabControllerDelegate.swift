//
//  MainTabControllerDelegate.swift
//  Anatomy Lab
//
//  Created by Hector Cen on 9/16/16.
//  Copyright © 2016 Hector Cen. All rights reserved.
//

import UIKit

class MainTabControllerDelegate: NSObject {
    
    typealias TabControllerHandler = (UIViewController?, NSError?) -> Void
    /// A completion handler that uses the returned values
    var tabHandler: TabControllerHandler?

}

extension MainTabControllerDelegate: UITabBarControllerDelegate {
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        tabHandler?(viewController, nil)
    }
    
}