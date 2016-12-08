//
//  UserSplitViewModel.swift
//  Anatomy Lab
//
//  Created by Hector Cen on 11/4/16.
//  Copyright © 2016 Hector Cen. All rights reserved.
//

import UIKit
import FontAwesome_swift

class UserSplitViewModel: NSObject {
    
    var title: String
    var image: UIImage
    
    required override init() {
        
        self.title = NSLocalizedString("Your profile", comment: "")
        self.image = UIImage.fontAwesomeIconWithName(FontAwesome.User, textColor: UIColor.whiteColor(), size: CGSizeMake(36.0, 36.0))
        super.init()
        
    }
    
}
