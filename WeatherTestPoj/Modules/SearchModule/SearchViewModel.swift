//
//  SearchViewModel.swift
//  WeatherTestPoj
//
//  Created by George on 30.03.2022.
//

import Foundation
import RxSwift
import RxCocoa

extension SearchViewModel {
    var tableContentDriver:Driver<[Cities]> {
        return tableContent.asDriverOnErrorJustComplete()
    }
}
class SearchViewModel:ViewModel {
    private let disposeBag = DisposeBag()
    private var tableContent = BehaviorSubject<[Cities]>(value: [])
    func transform(input: Input) -> Output {
        getCitiesData(input: input)
        saveCoordinate(input: input)
        return Output(tableContent: tableContentDriver)
    }
    
    private func getCitiesData(input: Input) {
        input.tapSearch.withLatestFrom(input.searchBarText).subscribe(onNext: {[weak self] text in
            guard let self = self else { return }
            
            let apiManager = ApiManager()
            apiManager.sendRequest(type: CitySearch.self, method: .GET, requestType: .getCityes(name: text), data: nil) {[weak self] data, error in
                guard let self = self else { return }
                guard let data = data else {
                    print(error.debugDescription)
                    return
                }
                self.tableContent.onNext(data.data)
            }
        }).disposed(by: disposeBag)
        
       
    }
    
    private func saveCoordinate(input:Input) {
        input.setCoordinate.subscribe(onNext: { coordinate in
            UserDefaults.standard.setValue(String(coordinate.latitude), forKeyPath: CoordinatesUDKeys.latitude.rawValue)
            UserDefaults.standard.setValue(String(coordinate.longitude), forKeyPath: CoordinatesUDKeys.longitude.rawValue)
        }).disposed(by: disposeBag)
    }
    
    struct Input {
        var searchBarText:Observable<String>
        var tapSearch:Observable<Void>
        var setCoordinate:Observable<LocationCoordinateDouble>
        
    }
    
    struct Output {
        var tableContent:Driver<[Cities]>
    }
    
}
