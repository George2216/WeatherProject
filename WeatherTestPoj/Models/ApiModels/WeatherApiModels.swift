//
//  WeatherMainModel.swift
//  WeatherTestPoj
//
//  Created by George on 30.03.2022.
//

import Foundation

struct WeatherMainModel:Codable {
    var list:[WeatherListItem]
    var city:CiryModel

    init(list:[WeatherListItem],city:CiryModel){
        self.list = list
        self.city = city
    }
    init() {
        self.list = []
        self.city = CiryModel(id: 0, name: "")
    }
}

struct WeatherListItem:Codable {
    var dt:Int
    var main:MainWeatherData
    var clouds:CloudsModel
    var wind:WindModel
    var dt_txt:String
}

struct WindModel:Codable {
    var speed:Double
}
struct CloudsModel:Codable {
    var all:Int
}

struct MainWeatherData:Codable {
    var temp_min:Double
    var temp_max:Double
    var humidity:Int
}

struct CiryModel:Codable {
    var id:Int
    var name:String
}
