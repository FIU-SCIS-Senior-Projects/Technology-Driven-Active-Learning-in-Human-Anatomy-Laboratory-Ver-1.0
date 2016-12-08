//
//  Lab.swift
//  Anatomy Lab
//
//  Created by Hector Cen on 9/12/16.
//  Copyright © 2016 Hector Cen. All rights reserved.
//

import Foundation
import SwiftyJSON

enum StationReview: Int {
    
    case Completed = 0
    case Pending
    case Favorite
    
}

class Lab: NSObject {
    
    private let titleKey = "title"
    private let subtitleKey = "subtitle"
    
    let title: String
    let subtitle: String
    
    init?(withJSON json: JSON){
        
        guard let title = json[titleKey].string,
            let subtitle = json[subtitleKey].string else {
            print("non-valid information")
            return nil
        }
        
        self.title = title
        self.subtitle = subtitle
    }

}
