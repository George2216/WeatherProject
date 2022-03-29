//
//  MainViewModel.swift
//  WeatherTestPoj
//
//  Created by Heorhii Churikov on 29.03.2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

enum MainTableSectionType {
    case mainSection
    case listOfTimes
    case listOfDates
}

enum MaintTableItems {
    case mainCell(model:MainModelCell)
    case timesCell(model:TimesModelCell)
    case datesCell(model:DatesModelCell)
}

typealias MainTableSection = SectionModel<MainTableSectionType,MaintTableItems>

class MainViewModel:ViewModel {
    private var items = BehaviorSubject<[MainTableSection]>(value: [])
    private let disposeBag = DisposeBag()
    func transform(input: Input) -> Output {
        subscribeLocation(input: input)
        bindData()
        return Output(items: itemsDriver)
    }
    
    struct Input {
        var coordinate:Observable<LocationCoordinate>
    }
    
    struct Output {
        var items:Driver<[MainTableSection]>
    }
    
    private func subscribeLocation(input: Input) {
        input.coordinate.subscribe(onNext: {[weak self] coordinate in
            guard let self = self else { return }
            print(coordinate)
        }).disposed(by: disposeBag)
    }
    
    
    private func bindData() {
        items.onNext([.init(model: .mainSection, items: [.mainCell(model: MainModelCell())]),.init(model: .listOfTimes, items: [.timesCell(model: TimesModelCell())]),.init(model: .listOfDates, items: [.datesCell(model: DatesModelCell()),.datesCell(model: DatesModelCell()),.datesCell(model: DatesModelCell()),.datesCell(model: DatesModelCell()),.datesCell(model: DatesModelCell()),.datesCell(model: DatesModelCell()),.datesCell(model: DatesModelCell()),.datesCell(model: DatesModelCell()),.datesCell(model: DatesModelCell()),.datesCell(model: DatesModelCell()),.datesCell(model: DatesModelCell())])])
    }
}
extension MainViewModel {
    var itemsDriver: Driver<[MainTableSection]> {
        return items.asDriverOnErrorJustComplete()
    }
}
