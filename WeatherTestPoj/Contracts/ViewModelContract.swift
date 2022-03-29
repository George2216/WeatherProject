//
//  ViewModelContract.swift
//  WeatherTestPoj
//
//  Created by Heorhii Churikov on 29.03.2022.
//

import Foundation

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    func transform(input:Input) -> Output
}
