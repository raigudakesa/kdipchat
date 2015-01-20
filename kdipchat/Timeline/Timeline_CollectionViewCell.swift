//
//  Timeline_CollectionViewCell.swift
//  kdip
//
//  Created by I Gusti Ngurah Aditya Dharma on 12/23/14.
//  Copyright (c) 2014 rai. All rights reserved.
//

import UIKit

class Timeline_CollectionViewCell: UICollectionViewCell {
    var cardView:CardView
    
    init(frame: CGRect, collectionViewLayout: UICollectionViewLayout){
        cardView = CardView(frame: frame)
        super.init(frame: frame)
        self.contentView.addSubview(cardView)
    }
    
    override init(frame: CGRect) {
        cardView = CardView(frame: frame)
        super.init(frame: frame)
        self.contentView.addSubview(cardView)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCardText(text:String){
        self.cardView.label.text = text
    }
    
    override func layoutSubviews() {
        self.cardView.frame = self.bounds
    }
}
