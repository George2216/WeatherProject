//
//  MainCell.swift
//  WeatherTestPoj
//
//  Created by Heorhii Churikov on 29.03.2022.
//

import UIKit
import SnapKit

class MainCell: UITableViewCell {
    var data:MainModelCell? {
        didSet {
            guard let data = data else { return }
            backgroundColor = GlobalData.share.colorFirstSection
            createCityName(text: "Poltava")
            createDateLabel(text: "ЧТ 19 ИЮЛЯ")
            createGeopositionButton()
            createMainImage(imageName: "cloud.sun")
            createWeatherStack(temperatureText: "27/19", humidityText: "33%", windinessText: "5m/sec")
            
        }
    }
    private let font:CGFloat = 25
    private var geopositionButton = UIButton(type: .custom)
    private var ciryName = LabelImageView()
    private var weatherImageView = UIImageView()
    private var dateLabel = UILabel()
   
    
    private func createCityName(text:String) {
        ciryName = LabelImageView(frame: .zero, font: UIFont.boldSystemFont(ofSize: font), spasing: -5, image: UIImage(systemName: "location.north.circle.fill") ?? UIImage(),text: text,color: .white)
                self.contentView.addSubview(ciryName)
        ciryName.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.leading.equalTo(20)
            make.trailing.equalTo(0)
        }
    }
    private func createDateLabel(text:String) {
        dateLabel.text = text
        dateLabel.textColor = .white
        dateLabel.font = UIFont.systemFont(ofSize: 15)
        self.contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(ciryName.snp.bottom).inset(-15)
            make.leading.equalTo(ciryName.snp.leading)
            make.height.equalTo(font)
        }
    }
    
    private func createGeopositionButton() {
        geopositionButton.setImage(UIImage(systemName: "mappin.circle.fill"), for: .normal)
        geopositionButton.tintColor = .white
        geopositionButton.contentVerticalAlignment = .fill
        geopositionButton.contentHorizontalAlignment = .fill
        self.contentView.addSubview(geopositionButton)
        geopositionButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.top.equalTo(20)
            make.width.equalTo(font + 5)
            make.height.equalTo(font + 5)

        }
    }
    
    private func createMainImage(imageName:String) {
        weatherImageView = UIImageView(image: UIImage(systemName: imageName))
        weatherImageView.tintColor = .white
        weatherImageView.contentMode = .scaleAspectFit
        weatherImageView.tintAdjustmentMode = .normal
        self.contentView.addSubview(weatherImageView)
        
        weatherImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(30)
            make.top.equalTo(dateLabel.snp.bottom).inset(-20)
            make.height.equalTo(font * 3 + 20)
            make.trailing.equalTo(contentView.snp.centerX).inset(-20)
            make.bottom.equalToSuperview().inset(30)
        }
    }
    private func createWeatherStack(temperatureText:String,humidityText:String,windinessText:String) {
        let stack = WeatherStack(frame: .zero, temperature: LabelImageModel(imageName: "thermometer", text: temperatureText), humidity: LabelImageModel(imageName: "drop.fill", text: humidityText), windiness: LabelImageModel(imageName: "wind", text: windinessText), font: UIFont.boldSystemFont(ofSize: 20))
        
        self.contentView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalTo(weatherImageView.snp.top)
            make.bottom.equalTo(weatherImageView.snp.bottom)
            make.leading.equalTo(weatherImageView.snp.trailing).inset(-30)
            make.trailing.equalToSuperview()
        }
    }

}
