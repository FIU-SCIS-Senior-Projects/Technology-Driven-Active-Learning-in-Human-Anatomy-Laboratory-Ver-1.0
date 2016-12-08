//
//  TakeQuiz.swift
//  Anatomy Lab
//
//  Created by Darian Mendez on 10/10/16.
//

import UIKit
import SwiftyJSON

class TakeQuiz: NSObject {

    private let titleKey = "title"
    private let subtitleKey = "subtitle"
    private let categoriesKey = "categories"
    private let questionsKey = "questions"
    private let quizDescriptionKey = "description"
    
    
    let title: String
    let subtitle: String
    let categories: String
    let quizdescription: String
       
    init?(withJSON json: JSON){
        
        guard let title = json[titleKey].string,
            let subtitle = json[subtitleKey].string,
            let quizdescription = json[quizDescriptionKey].string,
            let categories = json [categoriesKey].string else {
                print("non-valid information")
                return nil
        }
        
        self.title = title
        self.categories = categories
        self.subtitle = subtitle
        self.quizdescription = quizdescription
    }

}
