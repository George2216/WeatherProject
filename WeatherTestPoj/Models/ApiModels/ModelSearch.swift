//
//  ModelSearch.swift
//  WeatherTestPoj
//
//  Created by George on 30.03.2022.
//

import Foundation


struct CitySearch:Codable {
    var data:[Cities]
}

struct Cities:Codable {
    var latitude:Double
    var longitude:Double
    var name:String
    var country:String
}

