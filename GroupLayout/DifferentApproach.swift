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
    
    
    
    override func prepare() {
        
        guard let collectionView = collectionView, let delegate = delegate, layoutAttributes.isEmpty else { return }
        let sections = collectionView.numberOfSections
        
        layoutAttributes.removeAll()
        context.reset()
        
        for section in 0..<sections {
            minimumLineSpacing = delegate.collectionview(collectionView, layout: self, minimumLineSpacing: section)
            minimumInterItemLineSpacing = delegate.collectionview(collectionView, layout: self, minimumInterItemLineSpacing: section)
            var keySmall: String = ""
            var keyOther: String = ""
            var keyToPlayWith: String = ""
            var allowedToGoNextLine: Bool = false
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                
                let indexPath = IndexPath(item: item, section: section)
                let layoutAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let key = keyForLayoutAttributeItems(indexPath: indexPath)
                let itemSize = delegate.collectionView(collectionView, layout: self, sizeForItemAt: item)
                layoutAttributes[key] = layoutAttribute
                
                if !isHorizontallyAvailable(itemSize.width, minimumInterItemLineSpacing) {
                    print("------  item \(item) goes next line")
                    allowedToGoNextLine = true
                     
                    keySmall = getTheKeyOfTheLowestIndex()
                    keyOther = getTheOtherKey(key: keySmall)
                    
                    if layoutAttributes[keySmall]!.frame.minX + itemSize.width + minimumInterItemLineSpacing > contentWidth {
                           keyToPlayWith = keySmall
                    } else {
                           keyToPlayWith = keyOther
                        print(" keyToPlayWith \(item)")
                    }
                    context.cursor = CGPoint(x: layoutAttributes[keySmall]!.frame.minX,  y: (layoutAttributes[keySmall]!.frame.maxY + minimumLineSpacing))
                    
                }
                
                if allowedToGoNextLine {
                    keySmall = getTheKeyOfTheLowestIndex()
                    keyOther = getTheOtherKey(key: keySmall)
                }
                
                if !keySmall.isEmpty {
                    
                    if layoutAttributes[keySmall]!.frame.minX + itemSize.width + minimumInterItemLineSpacing > contentWidth {
                        keyToPlayWith = keyOther
                        
                    } else {
                        keyToPlayWith = keySmall
                    }
                    
                    context.cursor = .init(x: layoutAttributes[keyToPlayWith]!.frame.minX, y: layoutAttributes[keyToPlayWith]!.frame.maxY + minimumLineSpacing)
                    
                    let mockFrame = CGRect(x: context.cursor.x, y: context.cursor.y, width: itemSize.width, height: itemSize.height)
                    
                    if mockFrame.minY > layoutAttributes[keyToPlayWith]!.frame.maxY {
                        let yOffset = mockFrame.minY - layoutAttributes[keyToPlayWith]!.frame.maxY - minimumLineSpacing
                        context.cursor = .init(x: context.cursor.x, y: context.cursor.y - yOffset)
                    }
                    if item > 0 {
                        let prevLayout = layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: item - 1, section: section))]
                        if context.cursor.x - prevLayout!.frame.maxX > minimumInterItemLineSpacing {
                            let xoffSet = context.cursor.x - prevLayout!.frame.maxX - minimumInterItemLineSpacing
                            context.cursor = .init(x: context.cursor.x - xoffSet, y: context.cursor.y)
                        }
                    }
//                    if item == 7 {
//                        let widthx = context.cursor.x + itemSize.width
//                        context.cursor = .init(x: 0 ,y: context.cursor.y + minimumLineSpacing * 10)
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
                TESTPURPOSE[key] = layoutAttribute
//                if item == 13 {
//                    removeAndUpdateDictionary(dic: &TESTPURPOSE, key: keyOther)
//                    removeAndUpdateDictionary(dic: &TESTPURPOSE, key: keyToPlayWith)
//                } else {
                    removeAndUpdateDictionary(dic: &TESTPURPOSE, key: keyToPlayWith)
//                }
                
            }
        }
        contentSize = CGSize(width: contentWidth, height: setTheMaxY())
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
    private func getTheOtherKey(key: String) -> String {
        var keyToPass: String = ""
        TESTPURPOSE.forEach({ (key, value) in
            let found = key.matches(for: "[0-9]+", in: key)
            if found[0] != key {
                keyToPass = key
            }
        })
        return keyToPass
    }
    private func setTheMaxY() -> CGFloat {
            var max: CGFloat = 0.0
            TESTPURPOSE.forEach({(key, value ) in
                if value.frame.maxY >= max {
                    max = value.frame.maxY
                }
            })
            return max
        }
    private func removeAndUpdateDictionary(dic: inout [String: UICollectionViewLayoutAttributes] , key: String) {
        dic.removeValue(forKey: key)
    }
}


