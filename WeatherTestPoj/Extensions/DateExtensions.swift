//
//  DateExtensions.swift
//  WeatherTestPoj
//
//  Created by George on 30.03.2022.
//

import Foundation

extension Date {
    
    func getWeekDay() -> String{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EE"
            dateFormatter.locale = Locale.init(identifier: "ru_RU")
            let weekDay = dateFormatter.string(from: self)
            return weekDay
      }
    
    func getMonthName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: "ru_RU")
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: self)
        return nameOfMonth
    }
    func getNumberDay() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        let day = formatter.string(from: self)
        return day
    }
    
}

extension String {

   
    func fullDateSpase() -> Date? {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            df.locale = Locale.init(identifier: "ru_RU")
            
            return df.date(from: self)
        }
    
    func formattedDate(format:String) -> Date? {
        let df = DateFormatter()
        df.dateFormat = format
        df.locale = Locale.init(identifier: "ru_RU")
        
        return df.date(from: self)
    }
    
    func removeHoursFromFullDateAndConvet() -> Date? {
        let strDate = self.components(separatedBy: " ")[0]
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        df.locale = Locale.init(identifier: "ru_RU")
        
        return  df.date(from: strDate)

    }
    
    
}

