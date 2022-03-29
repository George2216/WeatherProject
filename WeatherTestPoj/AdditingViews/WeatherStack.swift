//
//  WeatherStack.swift
//  WeatherTestPoj
//
//  Created by Heorhii Churikov on 29.03.2022.
//

import UIKit

class WeatherStack: UIView {
    var stack = UIStackView()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame:CGRect,temperature:LabelImageModel,humidity:LabelImageModel,windiness:LabelImageModel,font:UIFont) {
        self.init(frame: frame)
        
        let temperatureView = createLabel(model: temperature, font: font)
        let humidityView = createLabel(model: humidity, font: font)
        let windinessView = createLabel(model: windiness, font: font)

        stack = UIStackView(arrangedSubviews: [temperatureView,humidityView,windinessView])
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
    
    private func createLabel(model:LabelImageModel,font:UIFont) -> LabelImageView {
        let labelImage = LabelImageView(frame: .zero, font: font, spasing: -5, image: UIImage(systemName: model.imageName) ?? UIImage(), text: model.text, color: .white)
       return labelImage
        
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
