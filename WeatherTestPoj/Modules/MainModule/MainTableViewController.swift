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

class MainTableViewController: UITableViewController , CLLocationManagerDelegate  , SelectCellDelegate {
    private var getLocationOnce = true
    private let disposeBag = DisposeBag()
    private let locationManager = CLLocationManager()
    private let mainCellIdentifier = "MainCellIdentifier"
    private let timesCellIdentifier = "TimesCellIdentifier"
    private let datesCellIdentifier = "DatesCellIdentifier"
    private let selectDayCell = PublishSubject<IndexPath>()
    private let selfLocationCoordinate = PublishSubject<LocationCoordinate>()
    private let viewModel = MainViewModel()
    
    private lazy var dataSourse: RxTableViewSectionedReloadDataSource<MainTableSection> =  .init(configureCell: { [weak self] (dataSource, tableView, indexPath, item) in
        guard let self = self else { return UITableViewCell()}
        switch item {
        case .mainCell(model:let data):
            return self.createMainCell(data: data, indexPath: indexPath)
        case .timesCell(model:let data) :
            return self.createTimesCell(data: data, indexPath: indexPath)
        case .datesCell(model:let data):
            return self.createDatesCell(data: data, indexPath: indexPath)
        }
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let output = viewModel.transform(input: MainViewModel.Input(coordinate: selfLocationCoordinate, selectCell: selectDayCell))
        subscribeOnSelectCell()
        bindDataToTableView(output: output)
        createTableView()
        setupLocationManager()
        navigationSettings()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setStatusBar()
    }
    
    func setStatusBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = GlobalData.share.colorFirstSection
        navigationController?.navigationBar.standardAppearance = appearance;
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        navigationController?.hideHairline()
        }
    
  
    private func navigationSettings() {
        navigationController?.navigationBar.backgroundColor = GlobalData.share.colorFirstSection
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func bindDataToTableView(output:MainViewModel.Output) {
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView
            .rx.setDelegate(self).disposed(by: disposeBag)
        output.items.drive(tableView.rx.items(dataSource: dataSourse)).disposed(by: disposeBag)
    }
    
    private func subscribeOnSelectCell() {
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            self.selectDayCell.onNext(indexPath)
        }).disposed(by: disposeBag)
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
        cell.data = data
        cell.tapGeopositionButton.subscribe(onNext:{[weak self] _ in
            guard let self = self else { return }
            let searchController = SearchViewController.instantiate()
            searchController.selectCellDelegate = self
            self.navigationController?.pushViewController(searchController, animated: true)
        }).disposed(by: cell.externalDisposeBag)
        cell.selectionStyle = .none
       return cell
    }
    
    private func createTimesCell(data:TimesModelCell,indexPath:IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: timesCellIdentifier, for: indexPath) as? TimesCell else { return UITableViewCell() }
        cell.data = data
        cell.selectionStyle = .none
       return cell
    }
    
    private func createDatesCell(data:DatesModelCell,indexPath:IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: datesCellIdentifier, for: indexPath) as? DatesCell else { return UITableViewCell() }
        cell.data = data
        cell.selectionStyle = .none
       return cell
    }
    
   
}

extension MainTableViewController {
    
    private func setupLocationManager() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func setCoordinatesFromDelegate(latitude: Double, longitude: Double) {
        selfLocationCoordinate.onNext(LocationCoordinate(latitude: String(latitude), longitude: String(longitude)))
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        guard viewModel.getCoordinates == nil else {
            getLocationOnce = false
        self.selfLocationCoordinate.onNext(viewModel.getCoordinates!)
            return
        }
        guard getLocationOnce else { return }
        self.selfLocationCoordinate.onNext(LocationCoordinate(latitude: String(locValue.latitude), longitude: String(locValue.longitude)))
        getLocationOnce = false
    }
}

