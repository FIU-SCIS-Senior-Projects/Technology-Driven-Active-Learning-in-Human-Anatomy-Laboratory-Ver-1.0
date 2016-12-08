//
//  GeneralTerminologyViewModel.swift
//  Anatomy Lab
//
//  Created by Hector Cen on 11/15/16.
//  Copyright © 2016 Hector Cen. All rights reserved.
//

import UIKit
import SwiftyJSON

class GeneralTerminologyViewModel: NSObject {
    
    private let labsKey = "labs"
    private let stationsKey = "stations"
    private let termsKey = "terms"
    
    private lazy var data: [JSON]? = {
        return Utilities.manager.loadData()?.arrayValue
    }()
    
    var terms = [(term: String, subterms: [JSON])]()
    private var stations: [[Int]]?
        
    func allTerms() -> [(term: String, subterms: [JSON])] {
        
        var _terms = [(term: String, subterms: [JSON])]()
        
        if let validData = data {
            for lab in validData {
                for station in lab[stationsKey].arrayValue {
                    for term in station[termsKey].arrayValue {
                        for (index, dict) in term.dictionaryValue {
                            _terms.append(term: index, subterms:dict.arrayValue)
                        }
                    }
                }
            }
        }
        terms = _terms
        return _terms
    }
    
    func terms(forStations stations: [[Int]]? = [[]]) -> [(term: String, subterms: [JSON])] {

        var _terms = [(term: String, subterms: [JSON])]()
        
        if let validStations = stations {
            self.stations = validStations
        }
        
        if let validStations = stations where !validStations.flatten().contains(1) {
            return allTerms()
        }
        
        if let validData = data {
            for (labIndex, lab) in validData.enumerate() {
                for (stationIndex, station) in lab[stationsKey].arrayValue.enumerate() {
                    if let validStations = stations where validStations[labIndex][stationIndex] == 1 {
                        for term in station[termsKey].arrayValue {
                            for (index, dict) in term.dictionaryValue {
                                _terms.append(term: index, subterms:dict.arrayValue)
                            }
                        }
                    }
                }
            }
        }
        terms = _terms
        return _terms
    }
    
    func terms(searchText: String) -> [(term: String, subterms: [JSON])] {
        
        return terms.filter({
            return $0.subterms.filter({ ($0.first?.0.containsString(searchText))! }).count > 0 || $0.term.containsString(searchText)
        })
    }
    
}
