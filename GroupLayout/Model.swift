//
//  Model.swift
//  GroupLayout
//
//  Created by AmirHossein EramAbadi on 3/13/23.
//

import Foundation
import UIKit

struct Model {
    var size: CGSize
}

protocol CustomLayoutDelegate: AnyObject {
    func collectionView(_ collectionview: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt section: Int) -> CGSize
    func collectionview(_ collectionview: UICollectionView, layout: UICollectionViewLayout, minimumLineSpacing section: Int) -> CGFloat
    func collectionview(_ collectionview: UICollectionView, layout: UICollectionViewLayout, minimumInterItemLineSpacing section: Int) -> CGFloat
}
