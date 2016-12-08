//
//  GeneralStationViewModel.swift
//  Anatomy Lab
//
//  Created by Hector Cen on 9/22/16.
//  Modified by Darian Mendez on 10/07/2016
//  Copyright © 2016 Hector Cen. All rights reserved.
//
/*The following class will get the JSON information for the specific station that the user selected
  Use this class to select the information that you need from the station
*/

import Foundation
import SwiftyJSON

final class GeneralStationViewModel: NSObject {
    
    private let titleKey = "title"
    private let videosKey = "videos"
    private let termsKey = "terms"
    private let takeQuizKey = "quizzes"
    private let takeQuizquestionsKey = "questions"
    //The following variable is use to access the quizzes information save in the json
    private let positionofthequizzesintheJSON: Int = 0
    private let positionofquestioninthejason:  Int = 0
    
    var stationData: JSON
    
    required init?(forStation station: JSON){
        stationData = station
        super.init()
    }
    
    func title() -> String {
        guard let validStationMetadata = Utilities.manager.loadMetadata(fromData: stationData) else {
            return "Error"
        }
        return validStationMetadata[titleKey].stringValue
    }
    
    func videoData() -> JSON {
        return stationData[videosKey]
    }
    
    func takeQuizData() -> JSON {
        return stationData[takeQuizKey]
    }
    
    func takeQuizMetadata(takeQuizData: JSON) -> JSON {
        return takeQuizData[positionofthequizzesintheJSON]["metadata"][0]
    }
    
    func takeQuizquestionsData(takeQuizData: JSON) ->JSON {
        return takeQuizData[positionofthequizzesintheJSON][takeQuizquestionsKey][positionofquestioninthejason]
    }
    
    func terms(searchText: String? = "") -> [(term: String, subterms: [JSON])] {
        
        var _terms = [(term: String, subterms: [JSON])]()
        for term in stationData[termsKey].arrayValue {
            for (index, dict) in term.dictionaryValue {
                if let searchTextEntered = searchText where searchTextEntered != "" {
                    if index.containsString(searchTextEntered) {
                        _terms.append(term: index, subterms:dict.arrayValue)
                    }else{
                        
                        if dict.arrayValue.filter({ ($0.first?.0.containsString(searchTextEntered))! }).count > 0 {
                            _terms.append((term: index, subterms:dict.arrayValue.filter({
                                ($0.first?.0.containsString(searchTextEntered))!
                            })))
                        }
                    }
                }else{
                    _terms.append(term: index, subterms:dict.arrayValue)
                }
            }
        }
        
        return _terms
    }

}
				