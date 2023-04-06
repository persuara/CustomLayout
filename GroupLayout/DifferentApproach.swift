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
            
            var firstLinePassed: Bool = false
            
            var allowedToGoNextLine: Bool = false
            var numberOfItemInRow = 0
            var TESTPURPOSE: [String: UICollectionViewLayoutAttributes] = [:]
            
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                
                var TEST: Int = 0
                let indexPath = IndexPath(item: item, section: section)
                let prevLayout = layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: item - 1, section: section))]
                let layoutAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let key = keyForLayoutAttributeItems(indexPath: indexPath)
                let itemSize = delegate.collectionView(collectionView, layout: self, sizeForItemAt: item)
                var calculatedMinimum: CGFloat?
                layoutAttributes[key] = layoutAttribute
                
                if !isAvailableSpace(itemSize.width, minimumInterItemLineSpacing) {
                    
                    print("||||| item \(item) goes next line")
                    print("item before \(item - 1)")
                    print("numberOfItemInRow \(numberOfItemInRow)")
                    //MARK: -- TEST
//                    let layoutBig = layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: item - 1, section: section))]
//                    calculatedMinimum = (contentWidth - layoutBig!.frame.maxX) / CGFloat(numberOfItemInRow + 2)
//                    print(calculatedMinimum)
//                    print("-------------")
//                    for i in (0..<numberOfItemInRow).reversed() {
//                        let layoutToChange = layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: (item - 1) - i , section: section))]
//                        if calculatedMinimum! > minimumInterItemLineSpacing {
//                            layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: item - i, section: section))]!.frame =
//                                .init(x: layoutToChange!.frame.maxX + calculatedMinimum!, y: layoutToChange!.frame.minY, width: layoutToChange!.frame.width, height: layoutToChange!.frame.height)
//                        }
//                        
//                    }
                    //MARK: -- END TEST
                    allowedToGoNextLine = true
                    firstLinePassed = true
                    
                    let neededlayout = layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: item - numberOfItemInRow, section: section))]
                    context.cursor = .init(x: neededlayout!.frame.minX, y:neededlayout!.frame.maxY + minimumLineSpacing)
                    allowedToGoNextLine = !allowedToGoNextLine
                    TEST = numberOfItemInRow
                    numberOfItemInRow = 0
                }
                
                if !allowedToGoNextLine && firstLinePassed && numberOfItemInRow != 0 {
                    let calc = item - (TEST) - 1
                    var tessst = calc - 1
                    
                    
                    let neededLayout = layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: calc, section: section))]
                    let prevLayout = layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: item - 1, section: section))]
                    context.cursor = .init(x: prevLayout!.frame.maxX, y: prevLayout!.frame.minY)
                    
                    if isAvailableSpace(itemSize.width, minimumInterItemLineSpacing) {
                        context.cursor = .init(x: neededLayout!.frame.maxX + minimumInterItemLineSpacing, y: neededLayout!.frame.minY)
                        
                    } else {
                        print("nexLine -> item \(item) numberOfItems in row: \(numberOfItemInRow)")
                        //MARK: -- TEST
//                        print(")
                        let layoutBig = layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: item - 1, section: section))]
                        calculatedMinimum = (contentWidth - layoutBig!.frame.maxX) / CGFloat(numberOfItemInRow)
                        
//                        for i in (0..<numberOfItemInRow).reversed() {
//                            let layoutToChange = layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: (item - 1) - i , section: section))]
//
//                            if calculatedMinimum! > minimumInterItemLineSpacing {
//                                layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: item - i, section: section))]!.frame =
//                                    .init(x: layoutToChange!.frame.maxX + calculatedMinimum!, y: layoutToChange!.frame.minY, width: layoutToChange!.frame.width, height: layoutToChange!.frame.height)
//                                context.cursor = .init(x: layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: item - i, section: section))]!.frame.minX, y: layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: item - i, section: section))]!.frame.minY)
////                                for k in 0..<layoutAttributes.count - 1 {
//                                    let layout =  layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: i, section: section))]!
////                                    if layoutToChange!.frame.intersects(layout.frame) {
////                                        layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: item - i, section: section))]!.frame =
////                                            .init(x: layoutToChange!.frame.minX, y: layout.frame.maxY + minimumLineSpacing, width: layoutToChange!.frame.width, height: layoutToChange!.frame.height)
////                                        context.cursor = .init(x: layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: item - i, section: section))]!.frame.minX, y: layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: item - i, section: section))]!.frame.minY)
////                                    }
////                                }
//                            }
//
//                        }
                     
                        //MARK: -- END TEST
                        let neededlayout = layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: item - numberOfItemInRow, section: section))]
//                        TEST = numberOfItemInRow
                        
                        numberOfItemInRow = 0
//                        allowedToGoNextLine = true
                        context.cursor = .init(x: neededlayout!.frame.minX, y:neededlayout!.frame.maxY + minimumLineSpacing)
//                        allowedToGoNextLine = false
                    }
                    
                    var mockFrame = CGRect(x: context.cursor.x, y: context.cursor.y, width: itemSize.width, height: itemSize.height)
                    for i in 0..<layoutAttributes.count - 1 {
                        let lastFrame = layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: i, section: section))]!.frame
                        if mockFrame.intersects(lastFrame) {
//                            print("mockFramee item \(item) has intersection with \(i)")
//                            if mockFrame.minY < lastFrame.maxY {
//                                context.cursor = .init(x: context.cursor.x, y: lastFrame.maxY + minimumLineSpacing)
//                            }
                            mockFrame = .init(x: context.cursor.x, y: context.cursor.y , width: itemSize.width, height: itemSize.height)
//                            if mockFrame.minX > 0 {
//                                context.cursor = .init(x: 0, y: context.cursor.y)
//                                mockFrame = .init(x: context.cursor.x, y: context.cursor.y , width: itemSize.width, height: itemSize.height)
//                            }
                        }
                    }
                    mockFrame = .init(x: context.cursor.x, y: context.cursor.y , width: itemSize.width, height: itemSize.height)
                    
                    if mockFrame.minY - neededLayout!.frame.maxY > 0  {
                        print(" |||||||||------- item \(item) -------||||||||| \(neededLayout?.indexPath.item)")
                        let yOffset = mockFrame.minY - neededLayout!.frame.maxY + minimumLineSpacing
                         context.cursor = .init(x: context.cursor.x, y: context.cursor.y - yOffset)
//                        context.cursor = .init(x: context.cursor.x, y: context.cursor.y - yOffset)
                    }
                }
                
                layoutAttribute.frame = CGRect(x: context.cursor.x, y: context.cursor.y, width: itemSize.width, height: itemSize.height)
               
                for i in 0..<layoutAttributes.count - 1 {
                    var offset: CGFloat = 0.0
                    let lastframe = layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: i, section: section))]?.frame ?? .zero
                    if layoutAttribute.frame.intersects(lastframe) == true {
                        print("-------      InterSection Alert    ------- \(item) with \(i)")
                        if layoutAttribute.frame.minY <= lastframe.maxY {
                            offset = lastframe.maxY - layoutAttribute.frame.minY + minimumLineSpacing
                            layoutAttribute.frame = CGRect(x: context.cursor.x,
                                                           y: lastframe.maxY + minimumLineSpacing , width: itemSize.width, height: itemSize.height)
                            context.cursor = .init(x: layoutAttribute.frame.minX, y: layoutAttribute.frame.minY)
                        }
//                        r
                    }
                }
                if !firstLinePassed {
                    context.cursor = CGPoint(x: context.cursor.x + itemSize.width + minimumInterItemLineSpacing , y: context.cursor.y)
                }
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
        return context.cursor.x + width + minimumInterItemLineSpacing * 2 < (contentWidth + collectionView!.contentInset.left)
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
}
