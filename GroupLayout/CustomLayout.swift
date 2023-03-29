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
            var dic: Dictionary<String, CGFloat> = [:]
            
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                var intersectsBaby: Bool = false
                let indexPath = IndexPath(item: item, section: section)
                let layoutAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let key = keyForLayoutAttributeItems(indexPath: indexPath)
                let itemSize = delegate.collectionView(collectionView, layout: self, sizeForItemAt: item)
                layoutAttributes[key] = layoutAttribute
                
                
                if !isAvailableSpace(itemSize.width, minimumInterItemLineSpacing) {
                    print("next Row: \(item)")
                    allowedToGoToNextLine = true
                    dic = getTheOffsetOfEachAttributeFromMax(maxY: setTheMaxY(), key: key)
                    keySmall = getTheIndexOfTheBiggestOffsetValue(offSet: dic)
                    var broItIntersect: Bool = false
                    var keyIntersectie: String = ""
                    var layouties: [UICollectionViewLayoutAttributes] = []
                    
                    //MARK: - check if it fits horisontally!
                    for i in 0..<layoutAttributes.count - 1 {
                        let layoutie = layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: i, section: section))]!
                        if itemSize.width > layoutie.frame.maxX {
                            layouties.append(layoutie)
                            broItIntersect = true
                        }
                    }
                    if layouties.count != 0 {
                        keyIntersectie = layoutAttributes.getTheKey(of: layouties[layouties.count - 1])
                    }
                    
                    if itemSize.width > layoutAttributes[keySmall]!.frame.maxX && broItIntersect == true {
                        let yoffSet = layoutAttributes[keyIntersectie]!.frame.maxY - layoutAttributes[keySmall]!.frame.maxY
                        context.cursor = .init(x: layoutAttributes[keySmall]!.frame.minX, y: layoutAttributes[keySmall]!.frame.maxY + yoffSet + minimumLineSpacing)
                    } else {
                        context.cursor = .init(x: layoutAttributes[keySmall]!.frame.minX, y: layoutAttributes[keySmall]!.frame.maxY + minimumLineSpacing)
                    }
                }
                
                if allowedToGoToNextLine {
                    dic = getTheOffsetOfEachAttributeFromMax(maxY: setTheMaxY(), key: key)
                    keySmall = getTheIndexOfTheBiggestOffsetValue(offSet: dic)
                    
                    //                    var broItIntersect: Bool = false
                    //                    var keyIntersectie: String = ""
                    //                    var layouties: [UICollectionViewLayoutAttributes] = []
                    //
                    //                    for i in 0..<layoutAttributes.count - 1 {
                    //                        let layoutie = layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: i, section: section))]!
                    //                        if itemSize.width > layoutie.frame.maxX {
                    //                            layouties.append(layoutie)
                    //                            broItIntersect = true
                    //                        }
                    //                    }
                    //                    if layouties.count != 0 {
                    //                        keyIntersectie = layoutAttributes.getTheKey(of: layouties[layouties.count - 1])
                    //                    }
                    //                    if itemSize.width > layoutAttributes[keySmall]!.frame.maxX && broItIntersect == true {
                    //                        let yoffSet = layoutAttributes[keyIntersectie]!.frame.maxY - layoutAttributes[keySmall]!.frame.maxY
                    //                        context.cursor = .init(x: layoutAttributes[keySmall]!.frame.minX, y: layoutAttributes[keySmall]!.frame.maxY + yoffSet + minimumLineSpacing)
                    ////                        broItIntersect = !broItIntersect
                    //                    } else {
                    //                        context.cursor = .init(x: layoutAttributes[keySmall]!.frame.minX, y: layoutAttributes[keySmall]!.frame.maxY + minimumLineSpacing)
                    //                    }
                }
                
                if !keySmall.isEmpty {
                    context.cursor = .init(x: layoutAttributes[keySmall]!.frame.minX, y: layoutAttributes[keySmall]!.frame.maxY + minimumLineSpacing)
                }
                
                layoutAttribute.frame = CGRect(x: context.cursor.x, y: context.cursor.y, width: itemSize.width, height: itemSize.height)
                if item == 4 {
                    print("++_+_+")
                    print(layoutAttribute.frame)
                }
                //MARK: - ORIGINAL
                //                for i in 0..<layoutAttributes.count - 1 {
                //                    let lastframe = layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: i , section: section))]?.frame ?? .zero
                //                        if layoutAttribute.frame.intersects(lastframe) == true {
                //                            if !keySmall.isEmpty {
                //                                if item != 3 {
                //                                    print("------Alert Intersection!------ (  \(item)  ) with (  \(i)   )")
                //                                    layoutAttribute.frame = CGRect(x: lastframe.minX,
                //                                                                   y: lastframe.maxY + minimumLineSpacing,
                //                                                                   width: itemSize.width,
                //                                                                   height: itemSize.height)
                //                                    context.cursor = CGPoint(x: lastframe.minX + minimumInterItemLineSpacing,
                //                                                             y: lastframe.maxY + minimumLineSpacing)
                //                                }
                //                            }
                //                    }
                //                }
                //MARK: - +++++++ TEST ++++++
                for i in 0..<layoutAttributes.count - 1 {
                    let layoutie = layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: i , section: section))]
                    guard layoutie != nil else { return }
                    let keyLayoutie = layoutAttributes.getTheKey(of: layoutie!)
                    if layoutAttribute.frame.intersects(layoutie!.frame) == true {
                        print("------Alert Intersection!------ (  \(item)  ) with (  \(i)   )")
                        //MARK: - Check if there's vertical space as well! NOT IMPLEMENTED YET
                        let yoffSet = layoutAttributes[keyLayoutie]!.frame.maxY - layoutAttributes[keySmall]!.frame.maxY
                        let deciderX = layoutAttributes[keySmall]!.frame.minX - layoutAttributes[keyLayoutie]!.frame.minX
                        let xoffSet = layoutAttributes[keyLayoutie]!.frame.maxX - layoutAttributes[keySmall]!.frame.minX
                        if deciderX < 0 {
                            layoutAttribute.frame = CGRect(x: context.cursor.x ,
                                                           y: context.cursor.y + yoffSet + minimumLineSpacing,
                                                           width: itemSize.width,
                                                           height: itemSize.height)
//                            context.cursor = CGPoint(x: context.cursor.x,
//                                                     y:  context.cursor.y + yoffSet)
                        } else {
                            layoutAttribute.frame = CGRect(x: context.cursor.x + xoffSet + minimumInterItemLineSpacing,
                                                           y: context.cursor.y /*+ yoffSet*/,
                                                           width: itemSize.width,
                                                           height: itemSize.height)
//                            context.cursor = CGPoint(x: context.cursor.x + xoffSet + minimumInterItemLineSpacing,
//                                                     y:  context.cursor.y + yoffSet)
                        }
                        
                    }
                }
            if allowedToGoToNextLine == false {
                context.cursor = CGPoint(x: context.cursor.x + itemSize.width + minimumInterItemLineSpacing, y: context.cursor.y)
            }
//               
            TESTPURPOSE[key] = layoutAttribute
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
private func getKeyForLayoutAttribute(for cursor: CGPoint) -> String? {
    var keyToPass: String?
    layoutAttributes.forEach({ (key, value) in
        if value.frame.minX == cursor.x && value.frame.minY == cursor.y {
            keyToPass = key
        }
    })
    return keyToPass
}

}
struct Context {
    var cursor: CGPoint = .zero
    mutating func reset() {
        cursor = .zero
    }
}
