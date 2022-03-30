//
//  LabelImageView.swift
//  WeatherTestPoj
//
//  Created by Heorhii Churikov on 29.03.2022.
//

import UIKit
import SnapKit
class LabelImageView: UIView {
    
    var label = UILabel()
    var imageView = UIImageView()
   


    func setup(font:UIFont,spasing:CGFloat,image:UIImage,text:String,color:UIColor) {
        imageView.tintColor = color
        label.textColor = color
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(font.pointSize)
            make.width.equalTo(font.pointSize)
        }
        
        label.text = text
        label.font = font
        self.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).inset(spasing)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
}
