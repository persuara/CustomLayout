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
            
            var largestY: CGFloat = 0.0
//            var indexlargestY: Int = 0
            var yOffset: [Int: CGFloat] = [:]

            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                let layoutAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let key = keyForLayoutAttributeItems(indexPath: indexPath)
                let itemSize = delegate.collectionView(collectionView, layout: self, sizeForItemAt: item)
                layoutAttributes[key] = layoutAttribute

                let testDictionary = layoutAttributes.sorted(by: { $0.value.frame.maxY < $1.value.frame.maxY })
                testDictionary.forEach({ key, value in
                    print(value.frame.maxY)
                    print("key: \(key)")
                })
                print("-------------")
                
                
                if !isAvailableSpace(itemSize.width, minimumInterItemLineSpacing) {
                    let indexlowest = findTheIndexOffLowest(yOffset: yOffset)
                    let key = keyForLayoutAttributeItems(indexPath: IndexPath(item: indexlowest, section: section))
                    let targetLayout = layoutAttributes[key]
                    context.cursor = CGPoint(x: targetLayout?.frame.minX ?? context.cursor.x,
                                             y: (targetLayout?.frame.maxY ?? context.cursor.y) + minimumLineSpacing)
                }



                layoutAttribute.frame = CGRect(x: context.cursor.x, y: context.cursor.y, width: itemSize.width, height: itemSize.height)
//                largestOffsetIndex(largestY: &largestY, yOffset: &yOffset)
//                print("lowest index: \(findTheIndexOffLowest(yOffset: yOffset))")
                context.cursor = CGPoint(x: context.cursor.x + itemSize.width + minimumInterItemLineSpacing, y: context.cursor.y)
            }
        }
        contentSize = CGSize(width: contentWidth, height: contentheight)
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
    private func largestOffsetIndex(largestY: inout CGFloat, yOffset: inout [Int: CGFloat]){
        var indexlargestY: Int = 0
        for (idx, layoutAtt) in layoutAttributes.enumerated() {
            if layoutAtt.value.frame.maxY > largestY {
                largestY = layoutAtt.value.frame.maxY
                indexlargestY = idx
            }
            if idx != indexlargestY {
                yOffset[idx] = largestY - layoutAtt.value.frame.maxY
//                print("\(largestY) - \(layoutAtt.value.frame.maxY) = \(largestY - layoutAtt.value.frame.maxY)")
                print("*****\(idx) -> \(yOffset[idx]!)******\n")
            }
        }
    }
    private func findTheIndexOffLowest(yOffset: [Int: CGFloat] ) -> Int {
        var max: CGFloat = 0.0
        var maxIndex: Int = 0
        for (idx, yoffsetValue) in yOffset.enumerated() {
            if yoffsetValue.value > max {
                max = yoffsetValue.value
                maxIndex = idx
            }
        }
        return maxIndex
    }
}
struct Context {
    var cursor: CGPoint = .zero
    mutating func reset() {
        cursor = .zero
    }
}
