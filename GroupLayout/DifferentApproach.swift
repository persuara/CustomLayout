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
            //            var keySmall: String = ""
            //            var keyOther: String = ""
            var firstLinePassed: Bool = false
            
            var allowedToGoNextLine: Bool = false
            var numberOfItemInRow = 0
            var specialNumbersInRow = 0
            
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                
                var TEST: Int = 0
                
                var firstItem: Bool = false
                let indexPath = IndexPath(item: item, section: section)
                let prevLayout = layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: item - 1, section: section))]
                let layoutAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let key = keyForLayoutAttributeItems(indexPath: indexPath)
                let itemSize = delegate.collectionView(collectionView, layout: self, sizeForItemAt: item)
                layoutAttributes[key] = layoutAttribute
                
                
              
                if !isAvailableSpace(itemSize.width, minimumInterItemLineSpacing) {
                    print("||||| item \(item) goes next line")
                    //                    TEST = 0
                    
                    allowedToGoNextLine = true
                    firstLinePassed = true
                    
                    //                    let prevLayout = layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: item - 1, section: section))]
                    let neededlayout = layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: item - numberOfItemInRow, section: section))]
                    context.cursor = .init(x: neededlayout!.frame.minX, y:neededlayout!.frame.maxY + minimumLineSpacing)
                    allowedToGoNextLine = !allowedToGoNextLine
                    TEST = numberOfItemInRow
                    numberOfItemInRow = 0
                }
                
                
                if !allowedToGoNextLine && firstLinePassed && numberOfItemInRow != 0 {
                    
                    let calc = item - (TEST) - 1
                    print("item: \(item) ||TEST = \(TEST)||| neededLayout -> \(calc)")
                    
                    let neededLayout = layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: calc, section: section))]
                    let prevLayout = layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: item - 1, section: section))]
                    context.cursor = .init(x: prevLayout!.frame.maxX, y: prevLayout!.frame.minY)
                    
                    if isAvailableSpace(itemSize.width, minimumInterItemLineSpacing) {
                        print("item \(item) -> has space")
//                        if neededLayout!.frame.minY !=
                        context.cursor = .init(x: neededLayout!.frame.maxX + minimumInterItemLineSpacing, y: neededLayout!.frame.minY)
                    } else {
                        print("item \(item) -> goes to else ")
                        let neededlayout = layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: item - numberOfItemInRow, section: section))]
                        context.cursor = .init(x: neededlayout!.frame.minX, y:neededlayout!.frame.maxY + minimumLineSpacing)
//                        allowedToGoNextLine = !allowedToGoNextLine
                    }
                    
                    
                    let mockFrame = CGRect(x: context.cursor.x, y: context.cursor.y, width: itemSize.width, height: itemSize.height)
                    
                    if mockFrame.minY > neededLayout!.frame.maxY {
                        let yOffset = mockFrame.minY - neededLayout!.frame.maxY + minimumLineSpacing
                        context.cursor = .init(x: context.cursor.x, y: context.cursor.y - yOffset)
                    }
                    //                        if mockFrame.maxX > contentWidth {
                    //                            context.cursor = .init(x: prevLayout!.frame.minX, y: prevLayout!.frame.maxY + minimumLineSpacing)
                    //                        }
                    //                        if mockFrame.minY > 0 {
                    //                            context.cursor = .init(x: 0, y: context.cursor.y)
                    //
                    //                        }
                    
                }
                
                layoutAttribute.frame = CGRect(x: context.cursor.x, y: context.cursor.y, width: itemSize.width, height: itemSize.height)
                
                for i in 0..<layoutAttributes.count - 1 {
                    var offset: CGFloat = 0.0
                    let lastframe = layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: i , section: section))]?.frame ?? .zero

                    if layoutAttribute.frame.intersects(lastframe) == true {
                        print("-------      InterSection Alert    ------- \(item) with \(i)")
                        if layoutAttribute.frame.minY < lastframe.maxY {
                            offset = lastframe.maxY - layoutAttribute.frame.minY + minimumLineSpacing
                            if item == 5 {
                                print("for i: \(i) yoffSet -> \(offset)")
                            }
                            layoutAttribute.frame = CGRect(x: context.cursor.x,
                                                           y: context.cursor.y + offset, width: itemSize.width, height: itemSize.height)
                            context.cursor = .init(x: context.cursor.x, y: context.cursor.y + offset)
                        }
                    }

                }
                if !firstLinePassed {
                    context.cursor = CGPoint(x: context.cursor.x + itemSize.width + minimumInterItemLineSpacing , y: context.cursor.y)
                }
                
                //                TESTPURPOSE[key] = layoutAttribute
                //                if allowedToRemove == true {
                //                    removeAndUpdateDictionary(dic: &TESTPURPOSE, key: keyToPlayWith)
                //                }
                numberOfItemInRow += 1
                
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
    private func setTheMaxYContentHeight() -> CGFloat {
        var max: CGFloat = 0.0
        layoutAttributes.forEach({(key, value ) in
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


