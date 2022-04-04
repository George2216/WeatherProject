//
//  GlobalData.swift
//  WeatherTestPoj
//
//  Created by Heorhii Churikov on 29.03.2022.
//

import Foundation
import UIKit

class GlobalData {
    
    static let share = GlobalData()
    
    let colorFirstSection:UIColor = #colorLiteral(red: 0.2864684761, green: 0.5658586025, blue: 0.8882957101, alpha: 1)
    let colorSecondSection:UIColor = #colorLiteral(red: 0.3582370281, green: 0.6213553548, blue: 0.9419576526, alpha: 1)
    
    
   
    
    func saveCoordinates(coordinates:LocationCoordinate) {
        UserDefaults.standard.setValue(coordinates.latitude, forKeyPath: CoordinatesUDKeys.latitude.rawValue)
        UserDefaults.standard.setValue(coordinates.longitude, forKeyPath: CoordinatesUDKeys.longitude.rawValue)
    }
    
    private init() {
        
    }
}

enum CoordinatesUDKeys:String {
    case latitude
    case longitude
}
