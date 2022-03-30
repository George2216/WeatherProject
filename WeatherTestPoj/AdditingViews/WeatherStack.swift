//
//  WeatherStack.swift
//  WeatherTestPoj
//
//  Created by Heorhii Churikov on 29.03.2022.
//

import UIKit

class WeatherStack: UIView {
    var stack = UIStackView()
    var temperatureLabel = LabelImageView()
    var humidityLabel = LabelImageView()
    var windinessLabel = LabelImageView()
   
    func setup(temperature:LabelImageModel,humidity:LabelImageModel,windiness:LabelImageModel,font:UIFont) {
        createLabel(label: &temperatureLabel, model: temperature, font: font)
        createLabel(label: &humidityLabel, model: humidity, font: font)
        createLabel(label: &windinessLabel, model: windiness, font: font)

        stack = UIStackView(arrangedSubviews: [temperatureLabel,humidityLabel,windinessLabel])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .leading
        
        self.addSubview(stack)
        
        stack.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
  
    
    
    private func createLabel(label:inout LabelImageView ,model:LabelImageModel,font:UIFont)   {
         label.setup(font: font, spasing: -5, image: UIImage(systemName: model.imageName) ?? UIImage(), text: model.text, color: .white)
        
    }
    
}
