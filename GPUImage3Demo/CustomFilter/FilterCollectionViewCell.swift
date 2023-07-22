//
//  FilterCollectionViewCell.swift
//  GPUImage3Demo
//
//  Created by 苍蓝猛兽 on 2023/7/14.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    
    private(set) lazy var filterLab: UILabel = {
        let lab = UILabel(frame: CGRectZero)
        lab.textColor = UIColor.cyan
        lab.font = UIFont.boldSystemFont(ofSize: 14)
        lab.numberOfLines = .zero
        lab.textAlignment = .center
        return lab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.brown.withAlphaComponent(0.5)
        self.contentView.layer.cornerRadius = 8
        self.contentView.clipsToBounds = true
        
        filterLab.frame = self.contentView.bounds
        self.contentView.addSubview(filterLab)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
