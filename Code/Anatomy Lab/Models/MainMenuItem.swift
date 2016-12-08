//
//  MainMenuItem.swift
//  Anatomy Lab
//
//  Created by Hector Cen on 9/19/16.
//  Copyright © 2016 Hector Cen. All rights reserved.
//

import Foundation
import SwiftyJSON

class MainMenuItem: NSObject {
    
    private let titleKey = "title"
    private let subtitleKey = "subtitle"
    
    let title: String
    let subtitle: String
    
    init?(withJSON json: JSON?){
        
        guard let validJSON = json, let title = validJSON[titleKey].string, let subtitle = validJSON[subtitleKey].string else {
            print("non-valid information")
            return nil
        }
        
        self.title = title
        self.subtitle = subtitle
        
        super.init()
    }
    
}
