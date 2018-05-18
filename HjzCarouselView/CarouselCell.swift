//
//  CarouselCell.swift
//  Mnl
//
//  Created by 黄江桂 on 2017/11/17.
//  Copyright © 2017年 海南美哪里信息技术有限公司. All rights reserved.
//

import UIKit

final class CarouselCell: UICollectionViewCell {
    
    lazy var imageView = UIImageView(frame: bounds)
    
    lazy var label: UILabel = {
        let label = UILabel(frame: bounds)
        label.textColor = .black
        label.font = .systemFont(ofSize: 12)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            let superview = self.superview as! CarouselView
            self.imageView.isHidden = !superview.isImgStyle
            self.label.isHidden = superview.isImgStyle
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
