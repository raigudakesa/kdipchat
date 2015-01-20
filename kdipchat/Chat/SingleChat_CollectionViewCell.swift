//
//  SingleChat_CollectionViewCell.swift
//  kdip
//
//  Created by Rai on 1/8/15.
//  Copyright (c) 2015 rai. All rights reserved.
//

import UIKit

class SingleChat_CollectionViewCell: JSQMessagesCollectionViewCell {
    var labelTest = UILabel()
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addSubview(labelTest)
    }
    
    override init() {
        super.init()
        self.addSubview(labelTest)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(labelTest)
        
    }
    
}
