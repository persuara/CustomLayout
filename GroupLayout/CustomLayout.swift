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
    fileprivate var countRow: Int = 0
    
    
    override func prepare() {
        
        guard let collectionView = collectionView, let delegate = delegate, layoutAttributes.isEmpty else { return }
        
        let sections = collectionView.numberOfSections
        
        layoutAttributes.removeAll()
        context.reset()
        
        for section in 0..<sections {
            var allowedToGoToNextLine: Bool = false
            minimumLineSpacing = delegate.collectionview(collectionView, layout: self, minimumLineSpacing: section)
            minimumInterItemLineSpacing = delegate.collectionview(collectionView, layout: self, minimumInterItemLineSpacing: section)
            var keySmall: String = ""
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                var allowablehorizentalSpace: CGFloat = 0.0
                let indexPath = IndexPath(item: item, section: section)
                let layoutAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let key = keyForLayoutAttributeItems(indexPath: indexPath)
                let itemSize = delegate.collectionView(collectionView, layout: self, sizeForItemAt: item)
                layoutAttributes[key] = layoutAttribute
                TESTPURPOSE[key] = layoutAttribute
                
                var dic: Dictionary<String, CGFloat>?
                dic = getTheOffsetOfEachAttributeFromMax(maxY: setTheMaxY(), key: key)
                keySmall = getTheIndexOfTheBiggestOffsetValue(offSet: dic!)
                
                if !isAvailableSpace(itemSize.width, minimumInterItemLineSpacing) {
                    allowedToGoToNextLine = true
                    if dic?[keySmall] != nil {
                        context.cursor = CGPoint(x: layoutAttributes[keySmall]!.frame.minX,  y: (layoutAttributes[keySmall]!.frame.maxY + minimumLineSpacing))
                    }
                }
                layoutAttribute.frame = CGRect(x: context.cursor.x, y: context.cursor.y, width: itemSize.width, height: itemSize.height)
                
                //----Mark TEST
                for i in 0..<layoutAttributes.count - 1 {
                    let lastframe = layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: i , section: section))]?.frame ?? .zero
                        if layoutAttribute.frame.intersects(lastframe) == true {
                            layoutAttribute.frame = CGRect(x: lastframe.minX,
                                                           y: lastframe.maxY + minimumLineSpacing,
                                                           width: itemSize.width,
                                                           height: itemSize.height)
                            
                            context.cursor = CGPoint(x: lastframe.minX, y: lastframe.maxY + minimumLineSpacing)
                    }
                }
                if allowedToGoToNextLine {
                    context.cursor = CGPoint(x: context.cursor.x + itemSize.width + minimumInterItemLineSpacing , y: (layoutAttributes[keySmall]?.frame.minY)!)
                } else {
                    allowablehorizentalSpace = contentWidth + minimumInterItemLineSpacing - (layoutAttribute.frame.maxX)
//                    for i in 0...countRow {
//                        var previousFrame = layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: i, section: section))]?.frame
//                        print("previous frame: \(previousFrame)")
//                        previousFrame = CGRect(x: (previousFrame?.minX ?? 0) + allowablehorizentalSpace / CGFloat(countRow), y: context.cursor.y, width: previousFrame?.width ?? 0.0, height: previousFrame?.height ?? 0.0)
//                        layoutAttributes[keyForSupplimentaryKindOf(indexPath: IndexPath(item: i, section: section))]?.frame = previousFrame!
//                        print("new frame: \(previousFrame)")
//                        countRow += 1
//                    }
                    layoutAttribute.frame = CGRect(x: allowablehorizentalSpace / 2 , y: 0, width: itemSize.width, height: itemSize.height)
                    context.cursor = .init(x: layoutAttribute.frame.maxX + allowablehorizentalSpace / 2, y: layoutAttribute.frame.minY)
                }
                removeAndUpdateForDictionary(dic: &TESTPURPOSE, key: keySmall)
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
