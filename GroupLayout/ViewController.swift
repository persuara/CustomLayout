//
//  ViewController.swift
//  GroupLayout
//
//  Created by AmirHossein EramAbadi on 3/13/23.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - This Bad Boy does not work properly if u change item 2 height to bellow 180
   lazy var array: [Model] = [
        .init(size: CGSize(width: 150, height: 90)),
        .init(size: CGSize(width: 70, height: 50)),
        .init(size: CGSize(width: 170, height: 200)),
        .init(size: CGSize(width: 150, height: 150)),
        .init(size: CGSize(width: 220, height: 100)),
        .init(size: CGSize(width: 80, height: 150)),
        .init(size: CGSize(width: 100, height: 80)),
        .init(size: CGSize(width: 130, height: 90)),
        .init(size: CGSize(width: 50, height: 100)),
        .init(size: CGSize(width: 150, height: 100)),
        .init(size: CGSize(width: widthConstant / 2 - 7, height: 100)),
        .init(size: CGSize(width: widthConstant / 3 - 7, height: 110)),
        .init(size: CGSize(width: widthConstant / 3 - 7, height: 90)),
        .init(size: CGSize(width: widthConstant / 3 - 7, height: 80)),
        .init(size: CGSize(width: widthConstant / 3 - 7, height: 190)),
        .init(size: CGSize(width: widthConstant / 3 - 7, height: 100)),
        .init(size: CGSize(width: widthConstant / 5 - 7, height: 100)),
        .init(size: CGSize(width: widthConstant / 2 - 7, height: 100)),
        .init(size: CGSize(width: widthConstant / 3 - 7, height: 100)),
        .init(size: CGSize(width: widthConstant / 2 - 7, height: 50)),
        .init(size: CGSize(width: widthConstant / 2 - 7, height: 180)),
        .init(size: CGSize(width: widthConstant / 5 - 7, height: 100)),
        .init(size: CGSize(width: widthConstant / 5 - 7, height: 100)),
        .init(size: CGSize(width: widthConstant / 5 - 7, height: 100)),
//    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 2 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 2 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
//    .init(size: CGSize(width: 100, height: widthConstant / 4 - 7)),
   ]

    
    
    
    lazy var layout: DifferentApproach = .init()
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
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionview.layoutSubviews()
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
extension ViewController: CustomLayoutDelegate {
    func collectionView(_ collectionview: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt section: Int) -> CGSize {
        return array[section].size
    }
    
    func collectionview(_ collectionview: UICollectionView, layout: UICollectionViewLayout, minimumLineSpacing section: Int) -> CGFloat {
        1
    }
    
    func collectionview(_ collectionview: UICollectionView, layout: UICollectionViewLayout, minimumInterItemLineSpacing section: Int) -> CGFloat {
        1
    }
    
    
}

