//
//  ViewController.swift
//  GroupLayout
//
//  Created by AmirHossein EramAbadi on 3/13/23.
//

import UIKit

class ViewController: UIViewController {
    
//    lazy var test: [Model] = [.init(size: CGSize(width: widthConstant / 3 - 7, height: 100)),
//                              .init(size: CGSize(width: widthConstant / 3 - 7, height: 100)),
//                              .init(size: CGSize(width: widthConstant / 3 - 7, height: 250)),
//                              .init(size: CGSize(width: widthConstant / 3 - 7, height: 250)),
//                              .init(size: CGSize(width: widthConstant / 3 - 7, height: 100)),
//                              .init(size: CGSize(width: widthConstant / 3 - 7, height: 100)),
//                              .init(size: CGSize(width: widthConstant / 3 - 7, height: 100)),
//                              .init(size: CGSize(width: widthConstant / 3 - 7, height: 100)),
//                              .init(size: CGSize(width: widthConstant / 3 - 7, height: 250)),
//                              .init(size: CGSize(width: widthConstant / 3 - 7, height: 100)),
//                              .init(size: CGSize(width: widthConstant / 3 - 7, height: 100)),
//                              .init(size: CGSize(width: widthConstant / 3 - 7, height: 250)),
//                              .init(size: CGSize(width: widthConstant / 3 - 7, height: 100)),
//                              .init(size: CGSize(width: widthConstant / 3 - 7, height: 100)),
//                              .init(size: CGSize(width: widthConstant / 3 - 7, height: 250)),
//                              .init(size: CGSize(width: widthConstant / 3 - 7, height: 250)),
//                              .init(size: CGSize(width: widthConstant / 3 - 7, height: 100)),
//                              .init(size: CGSize(width: widthConstant / 3 - 7, height: 100)),
//                              .init(size: CGSize(width: widthConstant / 3 - 7, height: 100)),
//                              .init(size: CGSize(width: widthConstant / 3 - 7, height: 100)),
//                              .init(size: CGSize(width: widthConstant / 3 - 7, height: 250)),
//                              .init(size: CGSize(width: widthConstant / 3 - 7, height: 100)),
//                              .init(size: CGSize(width: widthConstant / 3 - 7, height: 100)),
//                              .init(size: CGSize(width: widthConstant / 3 - 7, height: 250)),
//                              .init(size: CGSize(width: widthConstant / 3 - 7, height: 100)),
//                              .init(size: CGSize(width: widthConstant / 3 - 7, height: 100)),
//                              .init(size: CGSize(width: widthConstant / 3 - 7, height: 250)),
//                              .init(size: CGSize(width: widthConstant / 3 - 7, height: 250)),
//                              .init(size: CGSize(width: widthConstant / 3 - 7, height: 100)),
//                              .init(size: CGSize(width: widthConstant / 3 - 7, height: 100)),
//                              .init(size: CGSize(width: widthConstant / 3 - 7, height: 100)),
//                              .init(size: CGSize(width: widthConstant / 3 - 7, height: 100)),
//                              .init(size: CGSize(width: widthConstant / 3 - 7, height: 250)),
//                              .init(size: CGSize(width: widthConstant / 3 - 7, height: 100)),
//                              .init(size: CGSize(width: widthConstant / 3 - 7, height: 100)),
//                              .init(size: CGSize(width: widthConstant / 3 - 7, height: 250))
//    ]
    
    //MARK: - This Bad Boy does not work properly if u change item 2 height to bellow 180
    lazy var array: [Model] = [
        .init(size: CGSize(width: 150, height: 90)),
        .init(size: CGSize(width: 70, height: 50)),
        .init(size: CGSize(width: 160, height: 210)),
        .init(size: CGSize(width: 200, height: 150)),
        .init(size: CGSize(width: 105, height: 150)),
        .init(size: CGSize(width: 80, height: 150)), //5
        .init(size: CGSize(width: 160, height: 40)),
        .init(size: CGSize(width: 130, height: 140)),
        .init(size: CGSize(width: 150, height: 150)),
        .init(size: CGSize(width: 80, height: 100)),
        .init(size: CGSize(width: widthConstant / 3 - 7, height: 100)), // 10
        .init(size: CGSize(width: widthConstant / 3 - 7, height: 110)), // 11
        .init(size: CGSize(width: widthConstant / 2 - 7, height: 90)), // 12
        .init(size: CGSize(width: widthConstant / 1.1 - 7, height: 80)), // 13
        .init(size: CGSize(width: widthConstant / 3 - 7, height: 190)), // 14
        .init(size: CGSize(width: widthConstant / 3 - 7, height: 100)), // 15
        .init(size: CGSize(width: widthConstant / 5 - 7, height: 100)),
        .init(size: CGSize(width: widthConstant / 2 - 7, height: 100)),
        .init(size: CGSize(width: widthConstant / 3 - 7, height: 100)),
        .init(size: CGSize(width: widthConstant / 2 - 7, height: 50)),
        .init(size: CGSize(width: widthConstant / 2 - 7, height: 180)),
        .init(size: CGSize(width: widthConstant / 5 - 7, height: 100)),
        .init(size: CGSize(width: widthConstant / 5 - 7, height: 100)),
        .init(size: CGSize(width: widthConstant / 5 - 7, height: 100)), // 23
        .init(size: CGSize(width: 150, height: 90)),
        .init(size: CGSize(width: 70, height: 50)), // 25
        .init(size: CGSize(width: 160, height: 210)),
        .init(size: CGSize(width: 200, height: 150)),
        .init(size: CGSize(width: 105, height: 150)),
        .init(size: CGSize(width: 80, height: 150)),
        .init(size: CGSize(width: 100, height: 80)), // 30
        .init(size: CGSize(width: 110, height: 190)),
        .init(size: CGSize(width: 50, height: 100)),
        .init(size: CGSize(width: 80, height: 100)),
        .init(size: CGSize(width: 150, height: 90)),
        .init(size: CGSize(width: 70, height: 50)), // 35
        .init(size: CGSize(width: 160, height: 210)),
        .init(size: CGSize(width: 200, height: 150)),
        .init(size: CGSize(width: 105, height: 150)),
        .init(size: CGSize(width: 80, height: 150)),
        .init(size: CGSize(width: 100, height: 80)), // 40
        .init(size: CGSize(width: 130, height: 190)),
        .init(size: CGSize(width: 50, height: 100)),
        .init(size: CGSize(width: 80, height: 100)), // 43
        .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
        .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),// 45
        .init(size: CGSize(width: 200, height: widthConstant / 1.2 - 7)),
        .init(size: CGSize(width: 100, height: widthConstant / 2 - 7)),
        .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
        .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
        .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)), // 50
        .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
        .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
        .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
        .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
        .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)), // 55
        .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
        .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
        .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
        .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
        .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)), // 60
        .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
        .init(size: CGSize(width: 100, height: widthConstant / 2 - 7)),
        .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
        .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
        .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
        .init(size: CGSize(width: 110, height: widthConstant / 4 - 7)),
        .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
        .init(size: CGSize(width: 105, height: widthConstant / 4 - 7)),
        .init(size: CGSize(width: 200, height: widthConstant / 4 - 7)),
        .init(size: CGSize(width: 100, height: widthConstant / 5 - 7)), // 70
        .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
        .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
        .init(size: CGSize(width: 190, height: widthConstant / 2 - 7)),
        .init(size: CGSize(width: 100, height: widthConstant / 3 - 7)),
        .init(size: CGSize(width: 110, height: widthConstant / 4 - 7)),
        .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
        .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
        .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
        //    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
        //    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
        //    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
        //    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
        //    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
    ]
    
    
    
    
    lazy var layout: DifferentApproach = DifferentApproach()
    lazy var flowLayout: UICollectionViewFlowLayout = .init()
    lazy var collectionview: UICollectionView = {
        let view: UICollectionView = .init(frame: .zero, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        layout.delegate = self
        
        //        layout.collectionView?.layoutSubviews()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseIdentifier)
        return view
    }()
    
    
    lazy var widthConstant = view.frame.size.width
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionview)
        view.backgroundColor = .systemMint
        collectionview.contentInset = UIEdgeInsets(top: 50, left: 5, bottom: 0, right: 5)
        collectionview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        collectionview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        
        collectionview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 10).isActive = true
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        collectionview.collectionViewLayout.invalidateLayout()
        
    }
}
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier, for: indexPath) as! CollectionViewCell
        cell.backgroundColor = .systemBlue.withAlphaComponent(0.4)
        cell.label.text = "\(indexPath.item)"
        cell.layer.cornerRadius = 15
        return cell
    }
}
extension ViewController: CustomLayoutDelegate, UICollectionViewDelegateFlowLayout {
    
    //Custom Delegations
    func collectionView(_ collectionview: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt section: Int) -> CGSize {
        return array[section].size
    }
    
    func collectionview(_ collectionview: UICollectionView, layout: UICollectionViewLayout, minimumLineSpacing section: Int) -> CGFloat {
        5
    }
    
    func collectionview(_ collectionview: UICollectionView, layout: UICollectionViewLayout, minimumInterItemLineSpacing section: Int) -> CGFloat {
        1
    }
    
    //Flow Delegations
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        return array[indexPath.section].size
    //    }
    //    func collectionview(_ collectionview: UICollectionView, layout: UICollectionViewLayout, minimumInterItemLineSpacing section: Int) -> CGFloat {
    //        5
    //    }
    //    func collectionview(_ collectionview: UICollectionView, layout: UICollectionViewLayout, minimumLineSpacing section: Int) -> CGFloat {
    //        1
    //    }
}

