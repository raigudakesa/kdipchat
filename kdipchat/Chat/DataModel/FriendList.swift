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
    var avatar_tmp: String? = ""
    var avatar_tmpthumb: String? = ""
    var status: Bool = false
    var date: NSDate = NSDate()
    
    init()
    {
        
    }
    
    init(jid: String, fullname: String, avatar: String = "", avatar_tmp: String = "", avatar_tmpthumb: String = "", status: Bool = false, lastdate: NSDate = NSDate())
    {
        self.jid = jid
        self.name = fullname
        self.avatar = avatar
        self.avatar_tmp = avatar_tmp
        self.avatar_tmpthumb = avatar_tmpthumb
        self.status = status
        self.date = lastdate
    }
}