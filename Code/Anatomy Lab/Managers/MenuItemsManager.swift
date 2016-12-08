//
//  MenuItemsManager.swift
//  Anatomy Lab
//
//  Created by Hector Cen on 9/13/16.
//  Copyright © 2016 Hector Cen. All rights reserved.
//

import Foundation
import SwiftyJSON

enum MenuItemType: String {
    
    case Labs = "labs"
    case Station = "stations"
    
}

class MenuItemsManager: NSObject {
    
    typealias ItemsHandlerType = ([AnyObject]?, NSError?) -> Void
    /// A completion handler that uses the returned values
    var itemsHandler: ItemsHandlerType?
    
    var itemsType: MenuItemType?
    
    required init(forType type: MenuItemType) {
        self.itemsType = type
        super.init()
    }
    
    /**
     Return an array of menu items through an closure that has to be defined prior to performing the call for this method.
     
     - parameter lab:     The Lab to get the menu items for.
     - parameter station: The Station to get the menu items for.
     */
    func allItems(forLab lab: Int? = nil, station: Int? = nil){
        
        guard let appData = Utilities.manager.loadData(forLab: lab) else {
            print("unable to load app data")
            return
        }
        
        guard let _ = lab else {
            handleItems(fromAppData: appData)
            return
        }
        
        handleItems(fromAppData: appData["stations"])
        
    }
    
}

private extension MenuItemsManager {
    
    /**
     A private method that builds an array of items and returns it through an completion handler
     
     - parameter appData: The loaded app data from the static json file (lab.json)
     - parameter lab:     The lab, if any, to get data for.
     */
    func handleItems(fromAppData appData: JSON, lab: Int? = nil) {
        
        var _items = [AnyObject]()
        
        guard let items = appData.array else {
            itemsHandler?(nil, NSError(domain: "edu.fiu", code: 5000, userInfo: nil))
            return
        }
        
        for item in items {
            let metadata = Utilities.manager.loadMetadata(fromData: item)
            guard let _item = MainMenuItem(withJSON: metadata) else{
                print("non valid menu item information")
                continue
            }
            _items.append(_item)
        }
        
        itemsHandler?(_items, nil)
    }
    
}