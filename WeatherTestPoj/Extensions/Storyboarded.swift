//
//  Storyboarded.swift
//  WeatherTestPoj
//
//  Created by George on 30.03.2022.
//

import Foundation
import UIKit
protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        let identifier = String(describing: self)
        let stroryboard = UIStoryboard(name: "Main", bundle: .main)
        return stroryboard.instantiateViewController(withIdentifier: identifier) as! Self
    }
    
}
