//
//  GoogleSignInDelegate.swift
//  Anatomy Lab
//
//  Created by Hector Cen on 10/1/16.
//  Copyright © 2016 Hector Cen. All rights reserved.
//

import Foundation
import RealmSwift

class GoogleSignInDelegate: NSObject {
    
    private static let allowedDomain = "fiu.edu"
    
    typealias AuthenticationCompletionHandler = (GIDGoogleUser?, NSError?) -> Void
    var authenticationSignInCompletionHandler: AuthenticationCompletionHandler?
    var authenticationSignOutCompletionHandler: AuthenticationCompletionHandler?
    
    typealias AuthenticationPresentUICompletionHandler = (UIViewController) -> Void
    typealias AuthenticationDismissUICompletionHandler = () -> Void
    var authenticationPresentUICompletionHandler: AuthenticationPresentUICompletionHandler?
    var authenticationDismissUICompletionHandler: AuthenticationDismissUICompletionHandler?
    
}

extension GoogleSignInDelegate: GIDSignInDelegate {
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        
        if (error != nil) {
            authenticationSignInCompletionHandler?(nil, error)
        }else{
            if let domain = user.hostedDomain where domain == GoogleSignInDelegate.allowedDomain {
                authenticationSignInCompletionHandler?(user, nil)
            }else{
                let userInfo: [NSObject: AnyObject]? = [NSLocalizedDescriptionKey:NSLocalizedString("You can only access this app with your PantherMail account. Please try again.", comment: "")]
                authenticationSignInCompletionHandler?(nil, NSError(domain: "edu.fiu", code: -5000, userInfo: userInfo))
            }
        }
        
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
        authenticationSignOutCompletionHandler?(user, error)
    }
    
}

extension GoogleSignInDelegate: GIDSignInUIDelegate {
    
    func signIn(signIn: GIDSignIn!, presentViewController viewController: UIViewController!) {
        authenticationPresentUICompletionHandler?(viewController)
    }
    
    func signIn(signIn: GIDSignIn!, dismissViewController viewController: UIViewController!) {
        authenticationDismissUICompletionHandler?()
    }
    
}
