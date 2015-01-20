//
//  CardView.swift
//  kdip
//
//  Created by I Gusti Ngurah Aditya Dharma on 12/23/14.
//  Copyright (c) 2014 rai. All rights reserved.
//

import UIKit

class CardView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var label:UILabel
    var likeBtn: UIButton
    var commentBtn: UIButton
    var footer: UIView
    var header: UIView
    var propic: UIImageView
    var nameLbl: UILabel
    var timeLbl: UILabel
    
    override init(frame: CGRect) {
        self.label               = UILabel()
        self.label.font          = UIFont.boldSystemFontOfSize(24)
        self.label.textAlignment = NSTextAlignment.Center
        
        self.header = UIView()
        self.header.frame = CGRect(x: 0, y: 10, width: frame.width, height: 50)
        self.propic = UIImageView(frame: CGRect(x: 10, y:0 , width: 50, height: 50))
        self.propic.backgroundColor = UIColor.redColor()
        self.header.addSubview(self.propic)
        
        self.nameLbl = UILabel(frame: CGRect(x: 70, y: 0, width: frame.width - 80, height: 20))
        // self.nameLbl.backgroundColor = UIColor.greenColor()
        self.nameLbl.text = "Tebak Saya Siapa"
        self.nameLbl.font = UIFont.boldSystemFontOfSize(16)
        self.header.addSubview(self.nameLbl)
        
        
        self.timeLbl = UILabel(frame: CGRect(x: 70, y: 17, width: frame.width - 80, height: 20))
        // self.timeLbl.backgroundColor = UIColor.blueColor()
        self.timeLbl.text = "Yesterday, 8:00 AM"
        self.timeLbl.font = UIFont.systemFontOfSize(11)
        self.header.addSubview(self.timeLbl)
        
        self.footer = UIView()
        self.footer.frame = CGRect(x: 0, y: 120, width: frame.width, height: 30)
        self.likeBtn = UIButton()
        self.likeBtn.frame = CGRect(x: 0, y: 0, width: self.footer.frame.width/2, height: 30)
        self.likeBtn.setTitle("Like", forState: UIControlState.Normal)
        self.likeBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.likeBtn.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        self.likeBtn.layer.borderColor = UIColor.darkGrayColor().CGColor
        self.footer.addSubview(self.likeBtn)
        
        self.commentBtn = UIButton()
        self.commentBtn.frame = CGRect(x: self.footer.frame.width/2, y: 0, width: self.footer.frame.width/2, height: 30)
        self.commentBtn.setTitle("Comment", forState: UIControlState.Normal)
        self.commentBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.commentBtn.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        self.commentBtn.layer.borderColor = UIColor.darkGrayColor().CGColor
        
        self.footer.addSubview(self.commentBtn)
        super.init(frame: frame)
        
        self.addSubview(self.header)
        self.addSubview(self.footer)
        self.addSubview(self.label)
        self.backgroundColor    = UIColor.whiteColor()
        // self.layer.cornerRadius = 10.0
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.label.frame = self.bounds
    }

}
