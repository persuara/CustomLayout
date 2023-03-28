//
//  PSFlowLayout.swift
//  GroupLayout
//
//  Created by AmirHossein EramAbadi on 3/27/23.
//
import Foundation
import UIKit

class PSFlowLayout: UICollectionViewLayout {
    
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
    fileprivate var flowContext: FlowContext = .init()
    fileprivate var layoutAttributes: [String: UICollectionViewLayoutAttributes] = [:]
    fileprivate var TESTPURPOSE: [String: UICollectionViewLayoutAttributes] = [:]
    fileprivate var lastItemHeight: CGFloat = 0.0
    
    
    override func prepare() {
        
        guard let collectionView = collectionView, let delegate = delegate, layoutAttributes.isEmpty else { return }
        let sections = collectionView.numberOfSections
        
        layoutAttributes.removeAll()
        flowContext.reset()
        
        for section in 0..<sections {
            minimumLineSpacing = delegate.collectionview(collectionView, layout: self, minimumLineSpacing: section)
            minimumInterItemLineSpacing = delegate.collectionview(collectionView, layout: self, minimumInterItemLineSpacing: section)
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
                    allowedToGoNextLine = true
                    keySmall = getTheKeyOfTheLowestIndex()
                    flowContext.cursor = CGPoint(x: layoutAttributes[keySmall]!.frame.minX,  y: (layoutAttributes[keySmall]!.frame.maxY + minimumLineSpacing))
                }
                
                if allowedToGoNextLine == true {
                    keySmall = getTheKeyOfTheLowestIndex()
                }
                
                if !keySmall.isEmpty {
                    flowContext.cursor = .init(x: layoutAttributes[keySmall]!.frame.minX, y: layoutAttributes[keySmall]!.frame.maxY + minimumLineSpacing)
                }
                layoutAttribute.frame = CGRect(x: flowContext.cursor.x, y: flowContext.cursor.y, width: itemSize.width, height: itemSize.height)
                for i in 0..<layoutAttributes.count - 1 {
                    let lastframe = layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: i , section: section))]?.frame ?? .zero
                        if layoutAttribute.frame.intersects(lastframe) == true {
                            layoutAttribute.frame = CGRect(x: lastframe.minX, y: lastframe.maxY + minimumLineSpacing, width: itemSize.width, height: itemSize.height)
                            flowContext.cursor = CGPoint(x: lastframe.minX + minimumInterItemLineSpacing, y: lastframe.maxY + minimumLineSpacing)
                        }
                }
                flowContext.cursor = CGPoint(x: flowContext.cursor.x + itemSize.width + minimumInterItemLineSpacing , y: flowContext.cursor.y)
                removeAndUpdateDictionary(dic: &TESTPURPOSE, key: keySmall)
                lastItemHeight = itemSize.height
            }
        }
        contentSize = CGSize(width: contentWidth, height: flowContext.cursor.y + lastItemHeight + minimumLineSpacing * 6)
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
        return flowContext.cursor.x + width + minimumInterItemLineSpacing < (contentWidth + collectionView!.contentInset.left)
    }
    private func isHorizontallyAvailable(_ width: CGFloat, _ minimumInterItemLineSpacing: CGFloat ) -> Bool {
        return flowContext.cursor.x + width + minimumInterItemLineSpacing < contentWidth - minimumInterItemLineSpacing * 2
    }
    private func getTheKeyOfTheLowestIndex() -> String {
        var keyToPass: String = ""
        var min = CGFloat.greatestFiniteMagnitude
        TESTPURPOSE.forEach({(key, value) in
            let found = key.matches(for: "[0-9]+", in: key)
            let dF = Double(found[0])!
            if CGFloat(dF ) < min {
                min = CGFloat(dF )
               keyToPass = key
            }
        })
        return keyToPass
    }
    private func removeAndUpdateDictionary(dic: inout [String: UICollectionViewLayoutAttributes] , key: String) {
        dic.removeValue(forKey: key)
    }
}
struct FlowContext {
    var cursor: CGPoint = .zero
    mutating func reset() {
        cursor = .zero
    }
}

