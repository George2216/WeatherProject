//
//  DatesCell.swift
//  WeatherTestPoj
//
//  Created by Heorhii Churikov on 29.03.2022.
//

import UIKit

class DatesCell: UITableViewCell {

    var data:DatesModelCell? {
        didSet {
            guard let data = data else { return }
            color = data.isSelect ? GlobalData.share.colorSecondSection : .black
            setupColors(isSelectCell: data.isSelect)
            createLabels(dayOfTheWeekText: data.weekDay, temperatureRangeText: data.temperature)
            createImage(imageName: data.cloud.rawValue)
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
    }
    
    private var color:UIColor = .black
    private var dayOfTheWeekLabel = UILabel()
    private var temperatureRangeLabel = UILabel()
    private let weatherImageView = UIImageView()
    
    
    private func createLabels(dayOfTheWeekText:String,temperatureRangeText:String) {
        createLabel(label: &dayOfTheWeekLabel, text: dayOfTheWeekText)
        createLabel(label: &temperatureRangeLabel, text: temperatureRangeText)
        
        dayOfTheWeekLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }
        
        temperatureRangeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupColors(isSelectCell:Bool) {
        if isSelectCell {
            backgroundColor = .clear // very important
            layer.masksToBounds = false
            layer.shadowOpacity = 0.23
            layer.shadowRadius = 4
            layer.shadowOffset = CGSize(width: 0, height: 0)
            layer.shadowColor = GlobalData.share.colorSecondSection.cgColor
            contentView.backgroundColor = .white
            contentView.layer.cornerRadius = 8
            color = GlobalData.share.colorSecondSection
        } else {
            layer.shadowOpacity = 0
            contentView.layer.cornerRadius = 0
            contentView.layer.masksToBounds = true
            color = .black
        }
    }
    
    private func createImage(imageName:String) {
        weatherImageView.image = UIImage(systemName:imageName)
        weatherImageView.tintColor = color
        weatherImageView.contentMode = .scaleAspectFill
        contentView.addSubview(weatherImageView)
        weatherImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.height.equalTo(40)

        }
    }
    
    private func createLabel(label:inout UILabel,text:String) {
        label.text = text
        label.textColor = color
        label.font = UIFont.boldSystemFont(ofSize: 20)
        contentView.addSubview(label)
    }
    

    
    
}
