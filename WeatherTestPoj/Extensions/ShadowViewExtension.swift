//
//  ShadovViewExtension.swift
//  WeatherTestPoj
//
//  Created by George on 04.04.2022.
//

import Foundation
import UIKit
extension UIView {
    
    func setupShadow() {
        backgroundColor = .white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 10.0
        layer.shadowOpacity = 0
        layer.masksToBounds = false
        clipsToBounds = false
        
    }
    func removeShadow() {
        layer.shadowColor = nil
        layer.shadowOffset = .zero
        layer.shadowRadius = 0
        layer.shadowOpacity = 0
        layer.masksToBounds = true
        clipsToBounds = true
    }
    
}
