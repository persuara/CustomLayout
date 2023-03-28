//
//  Model.swift
//  GroupLayout
//
//  Created by AmirHossein EramAbadi on 3/13/23.
//
import UIKit

struct Model {
    var size: CGSize
}
protocol CustomLayoutDelegate: AnyObject {
    func collectionView(_ collectionview: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt section: Int) -> CGSize
    func collectionview(_ collectionview: UICollectionView, layout: UICollectionViewLayout, minimumLineSpacing section: Int) -> CGFloat
    func collectionview(_ collectionview: UICollectionView, layout: UICollectionViewLayout, minimumInterItemLineSpacing section: Int) -> CGFloat
}
extension Dictionary<String, UICollectionViewLayoutAttributes> {
    public func getTheKey(of valueAsked: UICollectionViewLayoutAttributes) -> String {
        var keyToPass: String = ""
        self.forEach({ (key, value) in
            if value == valueAsked {
                keyToPass = key
            }
        })
        return keyToPass
    }
}
