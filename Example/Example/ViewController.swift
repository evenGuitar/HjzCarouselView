//
//  ViewController.swift
//  Example
//
//  Created by 黄江桂 on 2018/5/18.
//  Copyright © 2018年 黄江桂. All rights reserved.
//

import UIKit
import HjzCarouselView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        
        let headerView = CarouselView(frame: CGRect(x: 0, y: 20, width: view.frame.width, height: 230))

        let items = ["https://www.google.cn/chrome/assets/common/images/marquee/chrome-new.jpg",
                     "https://www.google.cn/chrome/assets/common/images/marquee/benefits-2.jpg",
                     "https://www.google.cn/chrome/assets/common/images/marquee/benefits-1.jpg",
                     "https://www.google.cn/chrome/assets/common/images/marquee/benefits-4.jpg",
                     "https://www.google.cn/chrome/assets/common/images/marquee/benefits-5-mobile.png"]
        /// 图片模式
        ///
        /// 传入字符串数组，会自动识别是网络图片还是本地图片，
        /// 可以网络图片和本地图片混搭。
        ///
        /// 使用的是 Kingfisher 框架加载网络图片。
        /// 图片是要通过 https 认证的，
        /// 如果不是，请自行添加图片的域名到 info.plist 白名单中。
        headerView.imgContentMode = .scaleAspectFill
        headerView.set(items: items, in: .image)
        view.addSubview(headerView)
        
        
        let headline = CarouselView(frame: CGRect(x: 0, y: headerView.frame.maxY + 40, width: view.frame.width, height: 44))
        
        /// 头条模式
        ///
        /// 头条标题初始 x
        headline.lineOffsetX = 5
        /// 限制头条的显示行数，0 表示不限制
        headline.numberOfLines = 1
        /// 头条字体大小
        headline.fontSize = 12
        headline.set(items: ["“迎风一刀斩”，常山药业跌停！网红公司高管神操作，让韭菜情何以堪",
                               "Google Chrome 将从9月开始，默认 HTTPS ...",
                               "北约军人在乌克兰顿巴斯地区遇爆炸 至少3死2伤",
                               "[图]Chrome将逐步移除绿色小锁和“Secure”标记"], in: .label)
        view.addSubview(headline)
    }
}










