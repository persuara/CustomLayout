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
    fileprivate var TESTPURPOSE: [String: UICollectionViewLayoutAttributes] = [:]
    
    
    override func prepare() {
        
        guard let collectionView = collectionView, let delegate = delegate, layoutAttributes.isEmpty else { return }
        let sections = collectionView.numberOfSections
        
        layoutAttributes.removeAll()
        context.reset()
        
        for section in 0..<sections {
            minimumLineSpacing = delegate.collectionview(collectionView, layout: self, minimumLineSpacing: section)
            minimumInterItemLineSpacing = delegate.collectionview(collectionView, layout: self, minimumInterItemLineSpacing: section)
            var dic: Dictionary<String, CGFloat>?
            var keySmall: String = ""
            var allowedToGoNextLine: Bool = false
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                
                let indexPath = IndexPath(item: item, section: section)
                let layoutAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let key = keyForLayoutAttributeItems(indexPath: indexPath)
                let itemSize = delegate.collectionView(collectionView, layout: self, sizeForItemAt: item)
                layoutAttributes[key] = layoutAttribute
                
                TESTPURPOSE[key] = layoutAttribute
                
                if !isHorizontallyAvailable(itemSize.width, minimumInterItemLineSpacing) {
                    print("item does not have space \(item)")
                    allowedToGoNextLine = true
                    dic = getTheOffsetOfEachAttributeFromMax(maxY: setTheMaxY(), key: key)
                    keySmall = getTheIndexOfTheBiggestOffsetValue(offSet: dic!)
                    if !keySmall.isEmpty {
                        context.cursor = CGPoint(x: layoutAttributes[keySmall]!.frame.minX,  y: (layoutAttributes[keySmall]!.frame.maxY + minimumLineSpacing))
                    }
                }
                
                layoutAttribute.frame = CGRect(x: context.cursor.x, y: context.cursor.y, width: itemSize.width, height: itemSize.height)
                if allowedToGoNextLine == true {
                    dic = getTheOffsetOfEachAttributeFromMax(maxY: setTheMaxY(), key: key)
                    keySmall = getTheIndexOfTheBiggestOffsetValue(offSet: dic!)
//                    print("\(item) key small: \(keySmall)")
                }
                for i in 0..<layoutAttributes.count - 1 {
                    let lastframe = layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: i , section: section))]?.frame ?? .zero
                        if layoutAttribute.frame.intersects(lastframe) == true {
                            layoutAttribute.frame = CGRect(x: lastframe.minX, y: lastframe.maxY + minimumLineSpacing, width: itemSize.width, height: itemSize.height)
                            context.cursor = CGPoint(x: lastframe.minX + minimumInterItemLineSpacing, y: lastframe.maxY + minimumLineSpacing)
                        }
                }
                if !keySmall.isEmpty {
                    context.cursor = .init(x: layoutAttributes[keySmall]!.frame.minX, y: layoutAttributes[keySmall]!.frame.maxY + minimumLineSpacing)
                } else {
                    context.cursor = CGPoint(x: context.cursor.x + itemSize.width + minimumInterItemLineSpacing , y: context.cursor.y)
                }
                removeAndUpdateForDictionary(dic: &TESTPURPOSE, key: keySmall)
            }
        }
        contentSize = CGSize(width: contentWidth, height: context.cursor.y )
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
    private func isHorizontallyAvailable(_ width: CGFloat, _ minimumInterItemLineSpacing: CGFloat ) -> Bool {
        return context.cursor.x + width + minimumInterItemLineSpacing < contentWidth
    }
    private func setTheMaxY() -> Dictionary<String,CGFloat> {
        var max: CGFloat = 0.0
        var keyToPass: String = ""
        var dictionary: Dictionary<String,CGFloat> = .init()
        TESTPURPOSE.forEach({ (key, value ) in
            if value.frame.maxY >= max {
                max = value.frame.maxY
                keyToPass = key
            }
        })
        dictionary.updateValue(max, forKey: keyToPass)
        return dictionary
    }
    private func getTheOffsetOfEachAttributeFromMax(maxY: Dictionary<String,CGFloat>, key: String) -> Dictionary<String, CGFloat>{
        var offSet: CGFloat = 0.0
        var dictionary: Dictionary<String,CGFloat> = .init()
        TESTPURPOSE.forEach({ (key, value) in
            offSet = (maxY.first?.value ?? 0.0) - value.frame.maxY
            dictionary[key] = offSet
        })
        return dictionary
    }
    private func getTheIndexOfTheBiggestOffsetValue(offSet: Dictionary<String, CGFloat>) -> String {
        var keyToPass: String = ""
        var max: CGFloat = 0.0
        offSet.forEach({(key, value) in
            if value >= max {
                max = value
                keyToPass = key
            }
        })
        return keyToPass
    }
    private func removeAndUpdateForDictionary(dic: inout [String: UICollectionViewLayoutAttributes] , key: String) {
        dic.removeValue(forKey: key)
    }
}
struct Context {
    var cursor: CGPoint = .zero
    mutating func reset() {
        cursor = .zero
    }
}
