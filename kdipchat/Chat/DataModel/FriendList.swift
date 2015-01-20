//
//  FriendList.swift
//  kdipchat
//
//  Created by Rai on 1/19/15.
//  Copyright (c) 2015 rai. All rights reserved.
//

import Foundation

class FriendList {
    var jid: String = ""
    var name: String = ""
    var avatar: String? = ""
    var date: NSDate = NSDate()
    
    init()
    {
        
    }
    
    init(jid: String, fullname: String, avatar: String = "", lastdate:NSDate = NSDate())
    {
        self.jid = jid
        self.name = fullname
        self.avatar = avatar
        self.date = lastdate
    }
}