//
//  CarouselView.swift
//  Mnl
//
//  Created by apple on 2017/5/11.
//  Copyright © 2017年 海南美哪里信息技术有限公司. All rights reserved.
//

import UIKit
import Kingfisher

final class CarouselView: UIView {
    
    enum Style: Equatable {
        case image(Bool)    // 是否网络图片
        case label
    }
    
    var isImgStyle: Bool {
        return style != .label
    }
    
    var isEmpty: Bool {
        return items.isEmpty
    }
    
    /// 集合视图
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.backgroundView = UIImageView(image: placeholder)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CarouselCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionView
    }()
    /// 页控件
    private lazy var pageCtrl: UIPageControl? = {
        let pageControl = UIPageControl(frame: CGRect(x: 0, y: bounds.height - 37, width: bounds.width, height: 37))
        pageControl.currentPageIndicatorTintColor = .orange
        pageControl.pageIndicatorTintColor = .lightText
        // 如果只有一页, 则隐藏该指示器。默认为 false
        pageControl.hidesForSinglePage = true
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    /// 集合视图布局
    private var layout: UICollectionViewFlowLayout {
        return collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    }
    /// 样式
    private var style = Style.image(true) {
        didSet {
            if style == .label {
                pageCtrl = nil
            }
        }
    }
    /// 数据
    private lazy var items = [String]()
    /// 定时器
    private weak var timer: Timer?
    /// 占位图
    @objc var placeholder: UIImage?
    /// 点击 cell 的回调
    public var tapClosure:((Int) -> Void)?

    
    init(frame: CGRect, placeholder: UIImage) {
        super.init(frame: frame)
        self.placeholder = placeholder
        addSubview(collectionView)
        addSubview(pageCtrl!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(collectionView)
        addSubview(pageCtrl!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        // 重置 frame
        collectionView.frame = bounds
        layout.itemSize = bounds.size
        pageCtrl?.frame = CGRect(x: 0, y: bounds.height - 37, width: bounds.width, height: 37)
        
        // 刚开始需要偏移一位
        if items.count > 1 {
            if isImgStyle {
                collectionView.contentOffset.x = bounds.width
            }else {
                collectionView.contentOffset.y = bounds.height
            }
        }
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow != nil {
            addTimer()  // 移动到当前界面
        }else {
            removeTimer()   // 移除当前界面
        }
    }
    
    /// 设置数据
    public func set(items: [String], in style: Style) {
        
        self.items = items
        self.style = style
        
        // 先销毁定时器
        removeTimer()
        
        // 有两张以上的图片才启动定时器
        if items.count > 1 {
            self.items.insert(items.last!, at: 0)
            self.items.append(items.first!)
            addTimer()
        }
        
        pageCtrl?.numberOfPages = items.count
        layout.scrollDirection = isImgStyle ? .horizontal : .vertical
        collectionView.backgroundView = isImgStyle ? UIImageView(image: placeholder) : nil
        collectionView.reloadData()
    }
}


// MARK: UICollectionViewDataSource
extension CarouselView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CarouselCell
        
        let item = items[indexPath.item]

        switch style {
        case .image(let isNetwork):
            if !isNetwork {
                cell.imageView.image = UIImage(named: item)
            }else {
                cell.imageView.kf.setImage(with: URL(string: item), placeholder: placeholder)
            }
        default:
            cell.label.text = items[indexPath.item]
        }

        return cell
    }
}


// MARK: UICollectionViewDelegate
extension CarouselView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tapClosure?(indexPath.item - 1)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 四舍五入：Int（小数 + 0.5）
        let index = scrollView.contentOffset.x / scrollView.frame.width

        if isImgStyle {
            
            pageCtrl?.currentPage = Int(index - 0.5)
            
            if Int(index) == items.count - 1 {
                scrollView.contentOffset.x = scrollView.bounds.width
                pageCtrl?.currentPage = 0
            }else if scrollView.contentOffset.x == 0 {
                scrollView.contentOffset.x = CGFloat(items.count - 2) * bounds.width
                pageCtrl?.currentPage = items.count - 2
            }
        }else {
            let index = scrollView.contentOffset.y / scrollView.bounds.height
            if Int(index) == items.count - 1 {   // 最后一张时返回第一页
                scrollView.contentOffset.y = scrollView.bounds.height // scrollView 偏移量
            }
        }
    }
    
    /// 开始拖拽
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeTimer()
    }
    
    /// 停止拖拽
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        addTimer()
    }
}


// MARK: Timer
extension CarouselView {

    @objc private func scroll() {
        
        let offset = collectionView.contentOffset
        let item = isImgStyle ? Int(offset.x / bounds.width) : Int(offset.y / bounds.height)
        let position: UICollectionViewScrollPosition = isImgStyle ? .centeredHorizontally : .centeredVertically
        let path = IndexPath(item: item + 1, section: 0)
        
        collectionView.scrollToItem(at: path, at: position, animated: true)
    }
    
    private func addTimer() {
        if items.count > 1 && timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(scroll), userInfo: nil, repeats: true)
            RunLoop.main.add(timer!, forMode: .commonModes)
        }
    }
    
    private func removeTimer() {
        timer?.invalidate()
        timer = nil
    }
}






