//
//  SearchControllerDelegate.swift
//  Anatomy Lab
//
//  Created by Hector Cen on 10/21/16.
//  Copyright © 2016 Hector Cen. All rights reserved.
//

import Foundation

class SearchControllerDelegate: NSObject {

    typealias SearchControllerTextHandler = (String?) -> Void
    var searchControllerTextHandler: SearchControllerTextHandler?
    
    typealias SearchBarCancelButtonTapped = (Void) -> Void
    var searchBarCancelButtonTapped: SearchBarCancelButtonTapped?
    
}

//MARK: UISearchController searchResultUpdater
extension SearchControllerDelegate: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        searchControllerTextHandler?(searchController.searchBar.text)
    }
    
}

//MARK: UISearchBarDelegate
extension SearchControllerDelegate: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBarCancelButtonTapped?()
    }
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let allowedCharacters = NSCharacterSet(charactersInString:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ/ ").invertedSet
        let compSepByCharInSet = text.componentsSeparatedByCharactersInSet(allowedCharacters)
        let filter = compSepByCharInSet.joinWithSeparator("")
        return text == filter
    }
    
}