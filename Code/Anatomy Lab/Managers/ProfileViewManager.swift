//
//  ProfileViewManager.swift
//  Anatomy Lab
//
//  Created by Hector Cen on 11/5/16.
//  Copyright © 2016 Hector Cen. All rights reserved.
//

import UIKit

class ProfileViewManager: NSObject {
    
    typealias CompletionHandlerType = (ProfileViewModelType?, NSError?) -> Void
    var completionHandler: CompletionHandlerType?
    
    private typealias ImageFetchCompletion = (UIImage?, NSError?) -> Void
    
    func defaultProfile() {
        print("default profile")
        guard let validCompletionHandler = completionHandler else {
            print("valid completion handler")
            return
        }
        
        let currentUser = User.currentUser()
        var userProfile: ProfileViewModel?
        
        let fullName = currentUser?.fullname() ?? ""
        let defaultImage = UIImage(named: "fiu-logo")
        
        userProfile = ProfileViewModel(image: defaultImage ?? UIImage(), name: fullName)
        validCompletionHandler(userProfile, nil)
    }
    
}

private struct ProfileViewModel: ProfileViewModelType {
    
    var image = UIImage()
    var name = ""
    
}