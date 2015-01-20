//
//  ChatList.swift
//  kdip
//
//  Created by Rai on 12/22/14.
//  Copyright (c) 2014 rai. All rights reserved.
//

import Foundation

class ConversationData: FriendList {
    var group_id: String = "-1"
    var is_sender: Bool = false
    var message_id: String = ""
    var message: String = ""
    var message_multimediaurl: String = ""
    var message_multimedialocal: String = ""
    var message_multimediathumburl: String = ""
    var message_multimediathumblocal: String = ""
    var message_date: NSDate = NSDate()
    var message_type: Int = 1
    var message_status: Int = 0
    
    
    override init()
    {
        super.init()
    }
    
    init(jid: String, name: String, group_id: String = "-1", is_sender: Bool = false, message_id: String, message: String,
         message_multimediaurl: String = "", message_multimedialocal: String = "", message_multimediathumburl: String = "", message_multimediathumblocal: String = "", message_date: NSDate, message_type: Int = 1, message_status: Int = 0)
    {
        super.init(jid: jid, fullname: name)
        self.group_id = group_id
        self.is_sender = is_sender
        self.message_id = message_id
        self.message = message
        self.message_multimediaurl = message_multimediaurl
        self.message_multimedialocal = message_multimedialocal
        self.message_multimediathumburl = message_multimediathumburl
        self.message_multimediathumblocal = message_multimediathumblocal
        self.message_date = message_date
        self.message_type = message_type
        self.message_status = message_status
    }
    
}