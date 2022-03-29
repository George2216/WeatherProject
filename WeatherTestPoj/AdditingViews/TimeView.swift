//
//  TimeView.swift
//  WeatherTestPoj
//
//  Created by Heorhii Churikov on 29.03.2022.
//

import UIKit
import SnapKit

class TimeView: UIView {

   
    var stack = UIStackView()
    
    convenience init(frame:CGRect,hour:String,minute:String) {
        self.init(frame: frame)
        var hourLabel = UILabel()
        var minuteLabel = UILabel()
        
        createLabel(label: &hourLabel, text: hour, font: UIFont.systemFont(ofSize: 20))
        createLabel(label: &minuteLabel, text: minute, font: UIFont.systemFont(ofSize: 12))
        
        stack = UIStackView(arrangedSubviews: [ hourLabel,minuteLabel ])
        stack.distribution = .fillEqually
        stack.alignment = .top
        stack.axis = .horizontal
        stack.contentMode = .center
        self.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(10)
        }
    }
    
    
    
    func createLabel(label: inout UILabel,text:String,font:UIFont) {
        label.text = text
        label.textColor = .white
        label.font = font
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
