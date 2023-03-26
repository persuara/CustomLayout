//
//  CustomLayout.swift
//  GroupLayout
//
//  Created by AmirHossein EramAbadi on 3/13/23.
//

import Foundation
import UIKit
class CustomLayout: UICollectionViewLayout {
    
    public weak var delegate: CustomLayoutDelegate?
    
    fileprivate var contentWidth: CGFloat {
        guard collectionView != nil else {
            return .zero
        }
        let insets = collectionView!.contentInset
        return collectionView!.frame.size.width - (insets.left + insets.right)
    }
    fileprivate var contentheight: CGFloat {
        guard collectionView != nil else {
            return .zero
        }
        let insets = collectionView!.contentInset
        return collectionView!.frame.size.width - (insets.top + insets.bottom)
    }
    fileprivate var minimumLineSpacing: CGFloat = 0.0 {
        didSet {
            invalidateLayout()
        }
    }
    fileprivate var minimumInterItemLineSpacing: CGFloat = 0.0 {
        didSet {
            invalidateLayout()
        }
    }
    override var collectionViewContentSize: CGSize { contentSize }
    fileprivate var contentSize: CGSize = .zero
    fileprivate var context: Context = .init()
    fileprivate var layoutAttributes: [String: UICollectionViewLayoutAttributes] = [:]
    
    
    override func prepare() {
        
        guard let collectionView = collectionView, let delegate = delegate, layoutAttributes.isEmpty else { return }
        
        let sections = collectionView.numberOfSections
        
        layoutAttributes.removeAll()
        context.reset()
        
        for section in 0..<sections {
            minimumLineSpacing = delegate.collectionview(collectionView, layout: self, minimumLineSpacing: section)
            minimumInterItemLineSpacing = delegate.collectionview(collectionView, layout: self, minimumInterItemLineSpacing: section)
            var nextLine: Bool = false
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                let layoutAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let key = keyForLayoutAttributeItems(indexPath: indexPath)
                let itemSize = delegate.collectionView(collectionView, layout: self, sizeForItemAt: item)
                layoutAttributes[key] = layoutAttribute
                var dic: Dictionary<String, CGFloat>?
                
                dic = getTheOffsetOfEachAttributeFromMax(maxY: setTheMaxY(), key: key)
                
                let keySmall = getTheIndexOfTheBiggestOffsetValue(offSet: dic!)
                print("keySmall: \(keySmall)")
                
                if !isAvailableSpace(itemSize.width, minimumInterItemLineSpacing) {
                    if dic?[keySmall] != nil {
                        context.cursor = CGPoint(x: layoutAttributes[keySmall]!.frame.minX,  y: (layoutAttributes[keySmall]!.frame.maxY + minimumLineSpacing))
                    }
                    nextLine = true
                }
//                print("[ x: \(context.cursor.x) ,  y: \(context.cursor.y) ]")
                
                layoutAttribute.frame = CGRect(x: context.cursor.x, y: context.cursor.y, width: itemSize.width, height: itemSize.height)
                nextLine = !nextLine
                if item > 1 {
                    let lastframe = layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: item - 1, section: section))]?.frame ?? .zero
                    if layoutAttribute.frame.intersects(lastframe) == true {
                        layoutAttribute.frame = CGRect(x: lastframe.minX, y: lastframe.maxY + minimumLineSpacing, width: itemSize.width, height: itemSize.height)
                        context.cursor = CGPoint(x:  lastframe.minX, y: lastframe.maxY + minimumLineSpacing)
                    }
                }
                
                
                if dic?[keySmall] != nil && nextLine == true {
                    if layoutAttributes[key]!.frame.intersects(layoutAttributes[keySmall]!.frame) {
                        layoutAttribute.frame = CGRect(x: context.cursor.x + 50, y: context.cursor.y + 50, width: itemSize.width, height: itemSize.height)
                    } else {
                        context.cursor = CGPoint(x: context.cursor.x + itemSize.width + minimumInterItemLineSpacing, y: layoutAttributes[keySmall]!.frame.maxY + minimumLineSpacing)
                    }
                } else {
                    context.cursor = CGPoint(x: context.cursor.x + itemSize.width + minimumInterItemLineSpacing , y: context.cursor.y)
                    
                }
            }
        }
        contentSize = CGSize(width: contentWidth, height: context.cursor.y + contentheight)
    }
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        layoutAttributes[keyForLayoutAttributeItems(indexPath: indexPath)]
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        layoutAttributes.values.filter {$0.frame.intersects(rect)}
    }
    private func keyForSupplimentaryKindOf(indexPath: IndexPath) -> String {
        return "Supplimentary: \(indexPath.item), \(indexPath.section)"
    }
    private func keyForLayoutAttributeItems(indexPath: IndexPath) -> String {
        return "LayoutAttribute: \(indexPath.item), \(indexPath.section)"
    }
    private func isAvailableSpace(_ width: CGFloat, _ minimumInterItemLineSpacing: CGFloat ) -> Bool {
        return context.cursor.x + width + minimumInterItemLineSpacing < (contentWidth + collectionView!.contentInset.left)
    }
    private func setTheMaxY() -> Dictionary<String,CGFloat> {
        var max: CGFloat = 0.0
        var key: String = ""
        var dictionary: Dictionary<String,CGFloat> = .init()
        for (_, layoutAttribute) in layoutAttributes.enumerated() {
            if layoutAttribute.value.frame.maxY >= max {
                
                max = layoutAttribute.value.frame.maxY
                key = layoutAttribute.key
            }
        }
        dictionary.updateValue(max, forKey: key)
        return dictionary
    }
    
    private func getTheOffsetOfEachAttributeFromMax(maxY: Dictionary<String,CGFloat>, key: String) -> Dictionary<String, CGFloat>{
        var offSet: CGFloat = 0.0
        var key: String = ""
        var dictionary: Dictionary<String,CGFloat> = .init()
        
        for (_, layoutAttribute) in layoutAttributes.enumerated() {
            if layoutAttribute.key == key {
                continue
            }
            offSet = maxY.values.first! - layoutAttribute.value.frame.maxY
            key = layoutAttribute.key
            dictionary.updateValue(offSet, forKey: key)
        }
        return dictionary
    }
    private func getTheIndexOfTheBiggestOffsetValue(offSet: Dictionary<String, CGFloat>) -> String {
        var key: String = ""
        var min: CGFloat = CGFloat.greatestFiniteMagnitude
        for (_, yoffsetValue) in offSet.enumerated() {
            if yoffsetValue.value <= min && yoffsetValue.value != 0.0 {
                min = yoffsetValue.value
                key = yoffsetValue.key
            }
        }
        return key
    }
    
    
}
struct Context {
    var cursor: CGPoint = .zero
    mutating func reset() {
        cursor = .zero
    }
}
