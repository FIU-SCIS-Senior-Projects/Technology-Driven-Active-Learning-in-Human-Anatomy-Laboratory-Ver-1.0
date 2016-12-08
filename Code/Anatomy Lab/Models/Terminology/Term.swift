//
//  Terminology.swift
//  Anatomy Lab
//
//  Created by Hector Cen on 9/16/16.
//  Copyright © 2016 Hector Cen. All rights reserved.
//

import Foundation
import SwiftyJSON

class Term: NSObject {
    
    private let termKey = "terminology"
    private let definitionKey = "definition"
    
    let term: String
    let definition: String
    
    init?(withJSON json: JSON){
        
        guard let term = json[termKey].string,
            let definition = json[definitionKey].string else {
                print("invalid term information")
                return nil
        }
        
        self.term = term
        self.definition = definition
    }

}
