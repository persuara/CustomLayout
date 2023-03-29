//
//  DifferentApproach.swift
//  GroupLayout
//
//  Created by AmirHossein EramAbadi on 3/29/23.
//

import UIKit
class DifferentApproach: UICollectionViewLayout {
    
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
    fileprivate var lastItemHeight: CGFloat = 0.0
    
    
    override func prepare() {
        
        guard let collectionView = collectionView, let delegate = delegate, layoutAttributes.isEmpty else { return }
        let sections = collectionView.numberOfSections
        
        layoutAttributes.removeAll()
        context.reset()
        
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
                    context.cursor = CGPoint(x: layoutAttributes[keySmall]!.frame.minX,  y: (layoutAttributes[keySmall]!.frame.maxY + minimumLineSpacing))
                }
                
                if allowedToGoNextLine == true {
                    keySmall = getTheKeyOfTheLowestIndex()
                }
                
                if !keySmall.isEmpty {
                    let mockFrame = CGRect(x: context.cursor.x, y: context.cursor.y, width: itemSize.width, height: itemSize.height)
                    if mockFrame.minY > layoutAttributes[keySmall]!.frame.maxY {
                        let yOffset = mockFrame.minY - layoutAttributes[keySmall]!.frame.maxY - minimumLineSpacing 
                        context.cursor = .init(x: layoutAttributes[keySmall]!.frame.minX, y: layoutAttributes[keySmall]!.frame.maxY + minimumLineSpacing)
                    }
//                    if mockFrame.maxX + minimumInterItemLineSpacing > contentWidth {
//                        context.cursor = .init(x: layoutAttributes[keySmall]!.frame.minX, y: layoutAttributes[keySmall]!.frame.maxY + minimumLineSpacing)
//                    }
                }
                layoutAttribute.frame = CGRect(x: context.cursor.x, y: context.cursor.y, width: itemSize.width, height: itemSize.height)
                
                for i in 0..<layoutAttributes.count - 1 {
                    let lastframe = layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: i , section: section))]?.frame ?? .zero
                        if layoutAttribute.frame.intersects(lastframe) == true {
                            print("-------      InterSection Alert    ------- \(item) with \(i)")
                            if layoutAttribute.frame.minX < lastframe.maxX {
                                let offset = lastframe.maxX - layoutAttribute.frame.minX
                                layoutAttribute.frame = CGRect(x: context.cursor.x + offset + minimumInterItemLineSpacing,
                                                               y: context.cursor.y, width: itemSize.width, height: itemSize.height)
                            }
                            
                        }
                }
                context.cursor = CGPoint(x: context.cursor.x + itemSize.width + minimumInterItemLineSpacing , y: context.cursor.y)
                removeAndUpdateDictionary(dic: &TESTPURPOSE, key: keySmall)
                lastItemHeight = itemSize.height
            }
        }
        contentSize = CGSize(width: contentWidth, height: context.cursor.y + lastItemHeight + minimumLineSpacing * 6)
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
        return context.cursor.x + width + minimumInterItemLineSpacing < contentWidth - minimumInterItemLineSpacing * 2
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


