//
//  CollectionViewCell.swift
//  GroupLayout
//
//  Created by AmirHossein EramAbadi on 3/13/23.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    lazy var label: UILabel = .init(frame: .zero)
    static var reuseIdentifier: String {
        return String(describing: self.self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        self.addSubview(label)
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 30)
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: self.frame.size.width / 2.5).isActive = true
        label.heightAnchor.constraint(equalToConstant: self.frame.size.height / 2.5).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
