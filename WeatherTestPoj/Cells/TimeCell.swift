//
//  TimeCell.swift
//  WeatherTestPoj
//
//  Created by Heorhii Churikov on 29.03.2022.
//

import UIKit
import SnapKit

class TimeCell: UICollectionViewCell {
    var data:TimeModelCell? {
        didSet {
            guard let data = data else { return }
            self.backgroundColor = GlobalData.share.colorSecondSection
            createTimeView(hour: "19", minute: "00")
            createImageView(name: "cloud.sun")
            createTemperatureLabel(text: "26°")
        }
    }
    
    private var timeView = TimeView()
    
    private var weatherImage = UIImageView()
    private var temperatureLabel = UILabel()
    
    private func createTimeView(hour:String,minute:String) {
        timeView = TimeView(frame: .zero, hour: hour, minute: minute)
        self.contentView.addSubview(timeView)
        
        timeView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(20)

        }
    }
    
    private func createImageView(name:String) {
        weatherImage.image = UIImage(systemName: name)
        weatherImage.tintColor = .white
        weatherImage.contentMode = .scaleAspectFit
        self.contentView.addSubview(weatherImage)
        weatherImage.snp.makeConstraints { make in
            make.top.equalTo(timeView.snp.bottom).inset(-10)
            make.leading.equalToSuperview().inset(7)
            make.trailing.equalToSuperview().inset(7)
            make.height.equalTo(40)
        }
    }
    private func createTemperatureLabel(text:String) {
        temperatureLabel.text = text
        temperatureLabel.textColor = .white
        temperatureLabel.textAlignment = .center
        temperatureLabel.font = UIFont.systemFont(ofSize: 20)
        contentView.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherImage.snp.bottom).inset(-5)
            make.leading.equalToSuperview().inset(5)
            make.trailing.equalToSuperview().inset(5)
            make.bottom.equalToSuperview()

        }
    }
}
