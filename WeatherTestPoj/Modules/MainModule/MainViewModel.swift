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

enum MainTableItems {
    case mainCell(model:MainModelCell)
    case timesCell(model:TimesModelCell)
    case datesCell(model:DatesModelCell)
}

typealias MainTableSection = SectionModel<MainTableSectionType,MainTableItems>

class MainViewModel:ViewModel {
    private let fullData = BehaviorSubject<WeatherMainModel>(value: WeatherMainModel())
    private var selectedItem = BehaviorSubject<Int>(value: 0)
    private var items = BehaviorSubject<[MainTableSection]>(value: [])
    private let disposeBag = DisposeBag()
    
    var getCoordinates:LocationCoordinate? {
        guard  let latitude = UserDefaults.standard.value(forKey: CoordinatesUDKeys.latitude.rawValue) as? String else { return nil }
        guard let longitude = UserDefaults.standard.value(forKey: CoordinatesUDKeys.longitude.rawValue) as? String else { return nil }
        
        return LocationCoordinate(latitude: latitude, longitude: longitude)
    }
    
    func transform(input: Input) -> Output {
        subscribeOnChangeLocation(input: input)
        createTableData()
        subscribeOnSelectCell(input: input)
        return Output(items: itemsDriver)
    }
    
    private func subscribeOnSelectCell(input: Input) {
        input.selectCell.subscribe(onNext:{[weak self] indexPath in
            guard let self = self else { return }
            guard indexPath.section == 2 else { return }
            self.selectedItem.onNext(indexPath.row)
        }).disposed(by: disposeBag)
        
    }
    
    private func subscribeOnChangeLocation(input: Input) {
        input.coordinate.subscribe(onNext: {[weak self] coordinate in
            guard let self = self else { return }
            let apiManager = ApiManager()
            apiManager.sendRequest(type: WeatherMainModel.self, method: .GET, requestType: .getMainWeatherData(lat: Double(coordinate.latitude) ?? 0, lon: Double(coordinate.longitude) ?? 0), data: nil) {[weak self] data, error in
                guard let self = self else { return }
                guard let data = data else {
                    print(error?.localizedDescription ?? "")
                    return
                }
                self.fullData.onNext(data)
            }
        }).disposed(by: disposeBag)
    }
    
    private func createTableData() {
        Observable.combineLatest(fullData, selectedItem).subscribe(onNext: { [weak self] data , selectIntex in
            guard let self = self else { return }
            guard !data.list.isEmpty else { return }
            let dataOfIndex = data.list[selectIntex]
            let listOfDates = self.createListOfDates(data:data.list)
            let fullDate = listOfDates[selectIntex][0].dt_txt.fullDateSpase() ?? Date()
            
            let weekName = fullDate.getWeekDay().uppercased()
            let monthName = fullDate.getMonthName().uppercased()
            let numberDay = fullDate.getNumberDay()
            
            let timesSectionData = self.createTimesList(data: listOfDates, selectedIndex: selectIntex)
            let datesSectionData = self.createDatesData(data: listOfDates, selectedIndex: selectIntex)
            let rangeTemperature = self.createRangeTemperature(data: listOfDates, selectedIndex:selectIntex )
            
            
            let mainSectionData = MainModelCell(dateString: "\(weekName), \(numberDay) \(monthName)", cityName: data.city.name, temperatureRange:"\(rangeTemperature.min)°" + "/" + "\(rangeTemperature.max)°", humidity: "\(dataOfIndex.main.humidity)", windiness: "\(dataOfIndex.wind.speed)", cloud: self.getCloudForHumidity(humidity: listOfDates[selectIntex][0].clouds.all))
            
           
            
            self.items.onNext([.init(model: .mainSection, items: [.mainCell(model: mainSectionData)]),.init(model: .listOfTimes, items: timesSectionData),.init(model: .listOfDates, items: datesSectionData)])
            
        }).disposed(by: disposeBag)
    }
    
    private func createRangeTemperature(data:[[WeatherListItem]],selectedIndex:Int) -> (min:Double,max:Double) {
        let content = data[selectedIndex]
        var minTemp:Double = 1000
        var maxTemp:Double = -1000
        for item in content {
            
            if minTemp > item.main.temp_min {
                minTemp = item.main.temp_min
            }
            if maxTemp < item.main.temp_max {
                maxTemp = item.main.temp_max
            }
        }
        
        return (min:convertCelvinToCelcius(celvin: minTemp),max:convertCelvinToCelcius(celvin: maxTemp))
    }
    
    private func createTimesList(data:[[WeatherListItem]],selectedIndex:Int) -> [MainTableItems] {
        let content = data[selectedIndex]
        var temporaryArray:[MainTableItems] = []
        var contentSection:[TimeModelCell] = []
        for item in content {
            let maxTemperatureC = self.convertCelvinToCelcius(celvin: item.main.temp_max)
            let date = item.dt_txt.fullDateSpase() ?? Date()
            let calendar = Calendar.current

            var hour = String(calendar.component(.hour, from: date))
            
            let minutes = String(calendar.component(.minute, from: date))
            if hour.count == 1 {
                hour += "0"
                hour = String(hour.reversed())
            }
            
            contentSection.append(TimeModelCell(hour: hour, minutes: minutes, cloud: getCloudForHumidity(humidity: item.clouds.all), temperature:  "\(maxTemperatureC)°"))
        }
        
        temporaryArray.append(.timesCell(model: TimesModelCell(timeArray: contentSection)))
        
        return temporaryArray
    }
    
    private func createListOfDates(data:[WeatherListItem]) -> [[WeatherListItem]] {
        
        var finishData:[[WeatherListItem]] = []
        var temporaryArray:[WeatherListItem] = []
        
        for item in data {
            if temporaryArray.isEmpty {
                temporaryArray.append(item)
            } else {
                let date = item.dt_txt.removeHoursFromFullDateAndConvet() ?? Date()
                let previousDate = temporaryArray.last?.dt_txt.removeHoursFromFullDateAndConvet() ?? Date()
                if date == previousDate {
                    temporaryArray.append(item)
                } else {
                    finishData.append(temporaryArray)
                    temporaryArray = []
                    temporaryArray.append(item)
                }
            }
        }
        return finishData
    }
    
    private func createDatesData(data:[[WeatherListItem]],selectedIndex:Int) -> [MainTableItems]  {
        var finishData:[MainTableItems] = []
        for (index , day ) in data.enumerated() {
            if !day.isEmpty {
                let dataForCell = day[0]
                let tempRange = createRangeTemperature(data: data, selectedIndex: index)
                let maxTemperatureC = tempRange.max
                let minTemperatureC = tempRange.min
                let fullDate = dataForCell.dt_txt.fullDateSpase() ?? Date()
                let weekName = fullDate.getWeekDay().uppercased()
                
                finishData.append(.datesCell(model: DatesModelCell(isSelect: selectedIndex == index, temperature: "\(minTemperatureC)°" + "/" + "\(maxTemperatureC)°", cloud: getCloudForHumidity(humidity:dataForCell.clouds.all ), weekDay: weekName)))
            }
        }
        return finishData
    }
    
    
    private func getCloudForHumidity(humidity:Int) -> Clouds {
        switch humidity {
        case _ where humidity > 95 :
            return .rain
        case _ where humidity > 80 && humidity < 95:
            return .cloud
        default :
            return .sun
        }
    }
    
    private func convertCelvinToCelcius(celvin:Double) -> Double {
        return  round((celvin - 273.15) * 10)/10
    }
    
    struct Input {
        var coordinate:Observable<LocationCoordinate>
        var selectCell:Observable<IndexPath>
    }
    
    struct Output {
        var items:Driver<[MainTableSection]>
    }
    
}
extension MainViewModel {
    var itemsDriver: Driver<[MainTableSection]> {
        return items.asDriverOnErrorJustComplete()
    }
}
