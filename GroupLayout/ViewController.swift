//
//  ViewController.swift
//  GroupLayout
//
//  Created by AmirHossein EramAbadi on 3/13/23.
//

import UIKit

class ViewController: UIViewController {
    
   lazy var array: [Model] = [
        .init(size: CGSize(width: widthConstant / 3 - 7, height: 110)),
        .init(size: CGSize(width: widthConstant / 3 - 7, height: 100)),
        .init(size: CGSize(width: widthConstant / 3 - 7, height: 150)),
        .init(size: CGSize(width: widthConstant / 3 - 7, height: 150)),
        .init(size: CGSize(width: widthConstant / 3 - 7, height: 290)),
        .init(size: CGSize(width: widthConstant / 3 - 7, height: 130)),
        .init(size: CGSize(width: widthConstant / 3 - 7, height: 110)),
        .init(size: CGSize(width: widthConstant / 3 - 7, height: 80)),
        .init(size: CGSize(width: widthConstant / 3 - 7, height: 50)),
        .init(size: CGSize(width: widthConstant / 3 - 7, height: 50)),
        .init(size: CGSize(width: widthConstant / 3 - 7, height: 50)),
        .init(size: CGSize(width: widthConstant / 3 - 7, height: 150)),
   ]

    
    
    
    lazy var layout: CustomLayout = .init()
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
}
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier, for: indexPath) as! CollectionViewCell
        cell.backgroundColor = .blue.withAlphaComponent(0.3)
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
        5
    }
    
    func collectionview(_ collectionview: UICollectionView, layout: UICollectionViewLayout, minimumInterItemLineSpacing section: Int) -> CGFloat {
        5
    }
    
    
}

