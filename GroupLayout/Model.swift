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
extension Array {
    public func makeDictionary() -> Dictionary<String, UICollectionViewLayoutAttributes>.Element {
        var dic: Dictionary<String, UICollectionViewLayoutAttributes>.Element?
        if !self.isEmpty {
            dic = self[self.count - 1] as! Dictionary<String, UICollectionViewLayoutAttributes>.Element
        }
        return dic!
    }
}
extension Dictionary<String, UICollectionViewLayoutAttributes> {
    public mutating func removeAndUpdate(for key: String) {
        self.removeValue(forKey: key)
//        self.remove(at: index)
    }
}
extension String {
    public func intersects(with key: String, dictionary: Dictionary<String, UICollectionViewLayoutAttributes> ) -> Bool {
//        guard let dictionary = dictionary else { return }
//        if (dictionary[self]?.frame.maxX != nil ? > dictionary[key]?.frame.minX
        return false
    }
}
