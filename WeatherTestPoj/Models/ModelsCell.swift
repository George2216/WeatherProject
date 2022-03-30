//
//  ModelsCell.swift
//  WeatherTestPoj
//
//  Created by Heorhii Churikov on 29.03.2022.
//

import Foundation

struct MainModelCell {
    var dateString:String
    var cityName:String
    var temperatureRange:String
    var humidity:String
    var windiness:String
    var cloud:Clouds
}

struct TimesModelCell {
    var timeArray:[TimeModelCell]
   
}
struct DatesModelCell {
    var isSelect:Bool
    var temperature:String
    var cloud:Clouds
    var weekDay:String
}

struct TimeModelCell {
    var hour:String
    var minutes:String
    var cloud:Clouds
    var temperature:String
}

