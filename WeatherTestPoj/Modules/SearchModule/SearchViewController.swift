//
//  SearchViewController.swift
//  WeatherTestPoj
//
//  Created by George on 30.03.2022.
//

import UIKit
import RxSwift
import RxCocoa

protocol SelectCellDelegate {
    func newCoordinate(latitude:Double, longitude:Double)
}
class SearchViewController: UITableViewController ,Storyboarded {
    private let disposeBag = DisposeBag()
    private var searchBar = UISearchBar()
    private var viewModel = SearchViewModel()
    private var tapSearch = PublishSubject<Void>()
    private let cellIdentifier = "SearchCellIdentifier"
    var selectCellDelegate:SelectCellDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        let output = viewModel.transform(input: SearchViewModel.Input(searchBarText: searchBar.rx.text.orEmpty.asObservable(), tapSearch: tapSearch))
        
        createSearhBar()
        createRightBarButton()
        setupTableView(output: output)
        subscribeOnTapCell()
    }
    
    private func createSearhBar() {
        searchBar.searchTextField.backgroundColor = .white
        navigationItem.titleView = searchBar
    }

    private func createRightBarButton() {
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .done, target: self, action: nil)
        searchButton.tintColor = .white
        navigationItem.rightBarButtonItem = searchButton
        searchButton.rx.tap.subscribe(onNext:{[weak self] _ in
            guard let self = self else { return }
            self.tapSearch.onNext(())
        }).disposed(by: disposeBag)
    }
    
    private func setupTableView(output:SearchViewModel.Output) {
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        output.tableContent.drive(tableView.rx.items(cellIdentifier: cellIdentifier)) { row , data , cell in
            var content = cell.defaultContentConfiguration()
            content.text = data.name + ", " + data.country
            cell.contentConfiguration = content
            cell.selectionStyle = .none
        }.disposed(by: disposeBag)
        
    }
    
    private func subscribeOnTapCell() {
        tableView.rx.modelSelected(Cities.self).subscribe(onNext: { [weak self] cities in
            guard let self = self else { return }
            self.selectCellDelegate?.newCoordinate(latitude: cities.latitude, longitude: cities.longitude)
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    
}
