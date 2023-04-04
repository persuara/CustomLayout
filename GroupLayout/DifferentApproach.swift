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
            
            var allowedToGoNextLine: Bool = false
            
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                var allowedToRemove = false
                var keyToPlayWith: String = ""
                var calculatedMinimumInterSpacing: CGFloat = 0.0
                let indexPath = IndexPath(item: item, section: section)
                let layoutAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let key = keyForLayoutAttributeItems(indexPath: indexPath)
                let itemSize = delegate.collectionView(collectionView, layout: self, sizeForItemAt: item)
                layoutAttributes[key] = layoutAttribute
                
                if !isHorizontallyAvailable(itemSize.width, minimumInterItemLineSpacing) {
                    print("------  item \(item) goes next line")
                    allowedToGoNextLine = true
                    let prevLayout = layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: item - 1, section: section))]
                    keySmall = getTheKeyOfTheLowestIndex()
                    
                    if !(layoutAttributes[keySmall]!.frame.minX + itemSize.width + minimumInterItemLineSpacing < contentWidth) {
                        
                        context.cursor = .init(x: prevLayout!.frame.minX, y: prevLayout!.frame.maxY + minimumLineSpacing)
                        keyToPlayWith = keyForLayoutAttributeItems(indexPath: IndexPath(item: item - 1, section: section))
                        allowedToRemove = true
                        if item == 7 {
                            print(keySmall)
                        }
                    } else {
                        keyToPlayWith = keySmall
                        allowedToRemove = true
                        context.cursor = CGPoint(x: layoutAttributes[keyToPlayWith]!.frame.minX,  y: (layoutAttributes[keyToPlayWith]!.frame.maxY + minimumLineSpacing))
                        if !isAvailableSpace(itemSize.width, minimumInterItemLineSpacing) {
                            allowedToRemove = false
                            if !(prevLayout!.frame.maxX + minimumInterItemLineSpacing + itemSize.width + minimumInterItemLineSpacing > contentWidth) {
                                context.cursor = .init(x: prevLayout!.frame.maxX + minimumInterItemLineSpacing, y: prevLayout!.frame.minY)
                                keyToPlayWith = keyForLayoutAttributeItems(indexPath: IndexPath(item: item - 1, section: section))
                                allowedToRemove = true
                                
                            } else {
                                context.cursor = .init(x: prevLayout!.frame.minX, y: prevLayout!.frame.maxY + minimumLineSpacing)
                                keyToPlayWith = keyForLayoutAttributeItems(indexPath: IndexPath(item: item - 1, section: section))
                                allowedToRemove = true
                                if item == 7 {
                                    print(keyToPlayWith)
                                }
                            }
                        }
                    }
                    allowedToGoNextLine = !allowedToGoNextLine
                }
                
                if !allowedToGoNextLine && !keySmall.isEmpty && keyToPlayWith.isEmpty {
                    let prevLayout = layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: item - 1, section: section))]
                    keySmall = getTheKeyOfTheLowestIndex()
                    keyToPlayWith = keySmall
                    if item == 7 {
                        print(keyToPlayWith)
                    }
//                    !(layoutAttributes[keyToPlayWith]!.frame.maxX + itemSize.width + minimumInterItemLineSpacing > contentWidth)
                    
                    if !isAvailableSpace(itemSize.width, minimumInterItemLineSpacing) {
                        allowedToRemove = false
                        if !(prevLayout!.frame.maxX + minimumInterItemLineSpacing + itemSize.width + minimumInterItemLineSpacing > contentWidth) {
                            context.cursor = .init(x: prevLayout!.frame.maxX + minimumInterItemLineSpacing, y: prevLayout!.frame.minY)
                            keyToPlayWith = keyForLayoutAttributeItems(indexPath: IndexPath(item: item - 1, section: section))
                            allowedToRemove = true
                            
                        } else {
                            context.cursor = .init(x: prevLayout!.frame.minX, y: prevLayout!.frame.maxY + minimumLineSpacing)
                            keyToPlayWith = keyForLayoutAttributeItems(indexPath: IndexPath(item: item - 1, section: section))
                            allowedToRemove = true
                           
                        }
                    } else {
                        if !(layoutAttributes[keySmall]!.frame.maxX + itemSize.width + minimumInterItemLineSpacing < contentWidth) {
                            context.cursor = .init(x: layoutAttributes[keyToPlayWith]!.frame.minX, y: layoutAttributes[keyToPlayWith]!.frame.maxY + minimumLineSpacing)
                            allowedToRemove = true
                        }
                    }
                    
                    let mockFrame = CGRect(x: context.cursor.x, y: context.cursor.y, width: itemSize.width, height: itemSize.height)
                     
                    if item > 0 {
                        
                        if context.cursor.x - prevLayout!.frame.maxX > minimumInterItemLineSpacing {
                            let xoffSet = context.cursor.x - prevLayout!.frame.maxX - minimumInterItemLineSpacing
                            context.cursor = .init(x: context.cursor.x - xoffSet, y: context.cursor.y)
                        }
                        if mockFrame.minY > layoutAttributes[keyToPlayWith]!.frame.maxY && mockFrame.minY != layoutAttributes[keyToPlayWith]!.frame.minY {
                            allowedToRemove = true
                            print("item \(item)")
                            let yOffset = mockFrame.minY - layoutAttributes[keyToPlayWith]!.frame.maxY - minimumLineSpacing
                            context.cursor = .init(x: context.cursor.x, y: context.cursor.y - yOffset)
                        }
                        if mockFrame.maxX > contentWidth {
                            context.cursor = .init(x: prevLayout!.frame.minX, y: prevLayout!.frame.maxY + minimumLineSpacing)
                        }
                        if mockFrame.minY > 0 {
                            context.cursor = .init(x: 0, y: context.cursor.y)
                            
                        }
                    }
                }
                layoutAttribute.frame = CGRect(x: context.cursor.x, y: context.cursor.y, width: itemSize.width, height: itemSize.height)
                
                for i in 0..<layoutAttributes.count - 1 {
                    var offset: CGFloat = 0.0
                    let lastframe = layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: i , section: section))]?.frame ?? .zero
                        if layoutAttribute.frame.intersects(lastframe) == true {
                            print("-------      InterSection Alert    ------- \(item) with \(i)")
                            if layoutAttribute.frame.minX < lastframe.maxX {
                                offset = lastframe.maxX - layoutAttribute.frame.minX
                                layoutAttribute.frame = CGRect(x: context.cursor.x + offset + minimumInterItemLineSpacing,
                                                               y: context.cursor.y, width: itemSize.width, height: itemSize.height)
                                context.cursor = .init(x: context.cursor.x + offset + minimumInterItemLineSpacing, y: context.cursor.y)
                            }
                            if layoutAttribute.frame.minX < lastframe.maxX {
                                offset = lastframe.maxX - layoutAttribute.frame.minX
                                layoutAttribute.frame = CGRect(x: lastframe.maxX +  minimumInterItemLineSpacing,
                                                               y: context.cursor.y, width: itemSize.width, height: itemSize.height)
                                context.cursor = .init(x: lastframe.maxX +  minimumInterItemLineSpacing, y: context.cursor.y)
                            }
//                            calculatedMinimumInterSpacing = (contentWidth - layoutAttribute.frame.maxX) / CGFloat(TESTPURPOSE.count)
//                            print(" for item \(item) -> calculated: \(calculatedMinimumInterSpacing)")
//                            if calculatedMinimumInterSpacing > minimumInterItemLineSpacing {
//                                layoutAttribute.frame = .init(x: context.cursor.x + calculatedMinimumInterSpacing, y: context.cursor.y, width: itemSize.width, height: itemSize.height)
//                            }
                        } 
                    
                }
                context.cursor = CGPoint(x: context.cursor.x + itemSize.width + minimumInterItemLineSpacing , y: context.cursor.y)
                TESTPURPOSE[key] = layoutAttribute
                if allowedToRemove == true {
                    removeAndUpdateDictionary(dic: &TESTPURPOSE, key: keyToPlayWith)
                }
                
            }
        }
        contentSize = CGSize(width: contentWidth, height: setTheMaxYContentHeight())
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
    private func setTheMaxYContentHeight() -> CGFloat {
            var max: CGFloat = 0.0
            TESTPURPOSE.forEach({(key, value ) in
                if value.frame.maxY >= max {
                    max = value.frame.maxY
                }
            })
            return max
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
    private func getTheOffsetOfEachAttributeFromMax(maxY: Dictionary<String,CGFloat>) -> Dictionary<String, CGFloat>{
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
    private func removeAndUpdateDictionary(dic: inout [String: UICollectionViewLayoutAttributes] , key: String) {
        dic.removeValue(forKey: key)
    }
}


