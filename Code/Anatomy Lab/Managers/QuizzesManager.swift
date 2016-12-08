//
//  QuizzesManager.swift
//  Anatomy Lab
//
//  Created by Hector Cen on 11/8/16.
//  Copyright © 2016 Hector Cen. All rights reserved.
//

import Foundation

class QuizzesManager: NSObject {
    
    typealias QuizzesHandlerType = ([Quiz]?, NSError?) -> Void
    var quizzesHandler: QuizzesHandlerType?
    
    func quizzes() {
        
        guard let currentUser = User.currentUser() else {
            print("No user to request quizzes for.")
            return
        }
        
        fetchQuizzesForUser(userId: currentUser.email)
        
    }

}


//MARK: Private API
extension QuizzesManager {
    
    func fetchQuizzesForUser(userId userId: String) {
        quizzesHandler?(nil, nil)
    }
    
}