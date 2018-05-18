//
//  CarouselCell.swift
//  Mnl
//
//  Created by 黄江桂 on 2017/11/17.
//  Copyright © 2017年 海南美哪里信息技术有限公司. All rights reserved.
//

import UIKit

final class CarouselCell: UICollectionViewCell {
    
    let imageView = UIImageView(frame: .zero)
    let label = UILabel(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.frame = bounds
        contentView.addSubview(imageView)
        
        label.textColor = .black
        contentView.addSubview(label)
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            
            let superview = self.superview?.superview as! CarouselView
            
            self.label.frame = CGRect(x: superview.lineOffsetX, y: 0, width: self.bounds.width - superview.lineOffsetX, height: self.bounds.height)
            self.label.numberOfLines = superview.numberOfLines
            self.label.isHidden = superview.isImgStyle
            self.label.font = .systemFont(ofSize: superview.fontSize)
            
            self.imageView.contentMode = superview.imgContentMode
            self.imageView.isHidden = !superview.isImgStyle
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}













