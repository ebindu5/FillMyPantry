//
//  SearchDAO.swift
//  FillMyPantry
//
//  Created by NISHANTH NAGELLA on 7/28/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation

class SearchDAO {
    
    static func getSearchResults(_ groceryCatalog : [Grocery], _ searchText: String)->[String]{
        var filteredItems = [String]()
        let searchTextLowerCased = searchText.lowercased()
        for grocery in groceryCatalog {
            
            if grocery.nameLowerCase.starts(with: searchTextLowerCased){
                filteredItems.append(grocery.name)
            }
            
            if filteredItems.count >= Constants.SEARCH_RESULTS_COUNT {
                break
            }
        }
        
        for grocery in groceryCatalog {
            
            if grocery.nameLowerCase.contains(searchTextLowerCased) && !grocery.nameLowerCase.starts(with: searchTextLowerCased){
                filteredItems.append(grocery.name)
            }
            
            if filteredItems.count >= Constants.SEARCH_RESULTS_COUNT {
                break
            }
        }
        
        if  !filteredItems.contains(searchText){
            filteredItems.insert(searchText, at: 0)
        }
        
        return filteredItems
        
    }
}
