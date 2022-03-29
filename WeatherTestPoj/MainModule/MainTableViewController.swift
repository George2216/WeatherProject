//
//  ViewController.swift
//  WeatherTestPoj
//
//  Created by Heorhii Churikov on 29.03.2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import CoreLocation

class MainTableViewController: UITableViewController , CLLocationManagerDelegate {
    private let disposeBag = DisposeBag()
    private let locationManager = CLLocationManager()

    private let mainCellIdentifier = "MainCellIdentifier"
    private let timesCellIdentifier = "TimesCellIdentifier"
    private let datesCellIdentifier = "DatesCellIdentifier"
    
    private let selfLocationCoordinate = PublishSubject<LocationCoordinate>()
    private let viewModel = MainViewModel()
    
    private lazy var dataSourse: RxTableViewSectionedReloadDataSource<MainTableSection> =  .init(configureCell: { [unowned self] (dataSource, tableView, indexPath, item) in
        switch item {
        case .mainCell(model:let data):
            return createMainCell(data: data, indexPath: indexPath)
        case .timesCell(model:let data) :
            return createTimesCell(data: data, indexPath: indexPath)
        case .datesCell(model:let data):
            return createDatesCell(data: data, indexPath: indexPath)
        }
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        let output = viewModel.transform(input: MainViewModel.Input(coordinate: selfLocationCoordinate))
        bindDataToTableView(output: output)
        createTableView()
        setupLocationManager()
    }
    
    // subscribes
    private func bindDataToTableView(output:MainViewModel.Output) {
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView
            .rx.setDelegate(self).disposed(by: disposeBag)
        output.items.drive(tableView.rx.items(dataSource: dataSourse)).disposed(by: disposeBag)
    }
    
    
}

// creation
extension MainTableViewController {
    private func createTableView() {
        tableView.register(MainCell.self, forCellReuseIdentifier: mainCellIdentifier)
        tableView.register(TimesCell.self, forCellReuseIdentifier: timesCellIdentifier)
        tableView.register(DatesCell.self, forCellReuseIdentifier: datesCellIdentifier)
        
    }
    
    private func createMainCell(data:MainModelCell,indexPath:IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: mainCellIdentifier, for: indexPath) as? MainCell else { return UITableViewCell() }
        cell.data = MainModelCell()
        cell.selectionStyle = .none
       return cell
    }
    
    private func createTimesCell(data:TimesModelCell,indexPath:IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: timesCellIdentifier, for: indexPath) as? TimesCell else { return UITableViewCell() }
        cell.data = TimesModelCell()
       return cell
    }
    
    private func createDatesCell(data:DatesModelCell,indexPath:IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: datesCellIdentifier, for: indexPath) as? DatesCell else { return UITableViewCell() }
        cell.data = DatesModelCell()
       return cell
    }
    
    private func setupLocationManager() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
}

extension MainTableViewController {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
          guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        selfLocationCoordinate.onNext(LocationCoordinate(latitude: String(locValue.latitude), longitude: String(locValue.longitude)))
      }
}

