//
//  Videos.swift
//  Anatomy Lab
//
//  Created by Darian Mendez on 10/4/16.
//

import Foundation
import SwiftyJSON

class Videos: NSObject {
    private let titleKey = "videotitle"
    private let descriptionKey = "description"
    private let urlKey = "url"
    
    let title: String
    let videodescription: String
    let url: String
    
    init?(withJSON json: JSON){
        
        guard let title = json[titleKey].string,
            let description = json[descriptionKey].string,
            let videourl = json [urlKey].string else {
                print("non-valid information")
                return nil
        }
        
        self.title = title
        self.videodescription = description
        self.url = videourl
    }
}
