//
//  TEST.swift
//  GroupLayout
//
//  Created by AmirHossein EramAbadi on 4/5/23.
//

import UIKit
class TEST: UICollectionViewLayout {
    
    static let shared = TEST()
    private override init() {super.init()}
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
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
            
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                
                let indexPath = IndexPath(item: item, section: section)
                let prevLayout = layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: item - 1, section: section))]
                let layoutAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let key = keyForLayoutAttributeItems(indexPath: indexPath)
                let itemSize = delegate.collectionView(collectionView, layout: self, sizeForItemAt: item)
                layoutAttributes[key] = layoutAttribute
                
                if !isAvailableSpace(itemSize.height, minimumInterItemLineSpacing) {
                    context.cursor = .init(x: 0, y: prevLayout!.frame.minY)
                    for i in 0..<layoutAttributes.count - 1 {
                        let lastframe = layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: i, section: section))]?.frame ?? .zero
                        layoutAttribute.frame = .init(x: 0, y: lastframe.maxY + minimumLineSpacing, width: itemSize.width, height: itemSize.height)
                        context.cursor = .init(x: layoutAttribute.frame.minX, y: layoutAttribute.frame.minY)
                    }
                }
                
                layoutAttribute.frame = CGRect(x: context.cursor.x, y: context.cursor.y, width: itemSize.width, height: itemSize.height)
                
                if item != 0 {
                    if isAvailableSpace(itemSize.width, minimumInterItemLineSpacing) {
                        print("\(item)")
                        context.cursor = .init(x: prevLayout!.frame.maxX + minimumInterItemLineSpacing, y: prevLayout!.frame.minY)
                    } else {
                        print("++++\(item)")
                        context.cursor = .init(x: 0, y: prevLayout!.frame.minY)
//                        for i in 0..<layoutAttributes.count - 1 {
//                            let lastframe = layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: i, section: section))]?.frame ?? .zero
//                            layoutAttribute.frame = .init(x: 0, y: lastframe.maxY + minimumLineSpacing, width: itemSize.width, height: itemSize.height)
//                            context.cursor = .init(x: layoutAttribute.frame.minX, y: layoutAttribute.frame.minY)
//                        }
                    }
                }
               
                for i in 0..<layoutAttributes.count - 1 {
                    let lastframe = layoutAttributes[keyForLayoutAttributeItems(indexPath: IndexPath(item: i , section: section))]?.frame ?? .zero
                    if layoutAttribute.frame.intersects(lastframe) == true {
                        print("-------      InterSection Alert    ------- \(item) with \(i)")

                        if layoutAttribute.frame.minY <= lastframe.maxY && layoutAttribute.frame.minY != lastframe.minY {

                            layoutAttribute.frame = CGRect(x: context.cursor.x,
                                                           y: lastframe.maxY + minimumLineSpacing , width: itemSize.width, height: itemSize.height)
                            context.cursor = .init(x: layoutAttribute.frame.minX, y: layoutAttribute.frame.minY)
                        }
                    }
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

