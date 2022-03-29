//
//  TimesCell.swift
//  WeatherTestPoj
//
//  Created by Heorhii Churikov on 29.03.2022.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TimesCell: UITableViewCell {
    
    var data:TimesModelCell? {
        didSet {
            guard let data = data else { return }
            backgroundColor = GlobalData.share.colorSecondSection
            createCollectionViewLayout()
            createCollectionView()
        }
    }
    
    private let disposeBag = DisposeBag()
    private let collectionCellIdentifier = "TimeCollectionCellIdentifier"
    private var collectionLayout = UICollectionViewFlowLayout()

    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private let collectionContent = BehaviorSubject<[TimeModelCell]>(value: [TimeModelCell(),TimeModelCell(),TimeModelCell(),TimeModelCell(),TimeModelCell(),TimeModelCell(),TimeModelCell(),TimeModelCell(),TimeModelCell(),TimeModelCell()])
    
    private func createCollectionViewLayout() {
        collectionLayout.scrollDirection = .horizontal
        collectionLayout.minimumLineSpacing = 5
        collectionLayout.minimumInteritemSpacing = 5
        collectionLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionLayout.itemSize = CGSize(width: 70, height: 120)
    }
    
    private func createCollectionView() {
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(TimeCell.self, forCellWithReuseIdentifier: collectionCellIdentifier)
        collectionView.backgroundColor = GlobalData.share.colorSecondSection
        collectionView.delegate = nil
        collectionView.dataSource = nil
        collectionView.setCollectionViewLayout(collectionLayout, animated: true)
        collectionContent.bind(to: collectionView.rx.items(cellIdentifier: collectionCellIdentifier, cellType: TimeCell.self)) { $2.data = $1 }.disposed(by: disposeBag)
        
        self.contentView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(120)
        }

        
    }
    
    
}
