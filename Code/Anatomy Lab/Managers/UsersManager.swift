//
//  UsersManager.swift
//  Anatomy Lab
//
//  Created by Hector Cen on 11/8/16.
//  Copyright © 2016 Hector Cen. All rights reserved.
//

import Foundation

class UsersManager: NSObject {
    
    typealias UsersHandlerType = ([User]?, NSError?) -> Void
    var usersHandler: UsersHandlerType?

}

//MARK: Private API
extension UsersManager {
    
    
    
}