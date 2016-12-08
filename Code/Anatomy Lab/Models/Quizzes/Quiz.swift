//
//  Quiz.swift
//  Anatomy Lab
//
//  Created by Hector Cen on 9/12/16.
//  Copyright © 2016 Hector Cen. All rights reserved.
//

import Foundation
import RealmSwift

class Quiz: Object {

    dynamic var belongsToStation = 1
    dynamic var stationBelongsToLab = 1
    
    dynamic var questionsQuantity = 0
    dynamic var correctlyAnsweredQuestions = 0
    
    dynamic var dateTaken = NSDate()
    dynamic var student: User?
    
}

//MARK: Public API
extension Quiz {
    
    func grade() -> Float { return Float(correctlyAnsweredQuestions / questionsQuantity) }
    
}