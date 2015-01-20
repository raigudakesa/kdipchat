//
//  ChatList.swift
//  kdip
//
//  Created by Rai on 12/22/14.
//  Copyright (c) 2014 rai. All rights reserved.
//

import Foundation

class ChatList {
    var name: String = ""
    var jid: String = ""
    var lastMessage: String = ""
    var lastMessageReceivedDate: NSDate = NSDate()
    var type: ChatListType = ChatListType.Single
    
    init()
    {
        
    }
    
    init(jid: String, name: String, lastMessage: String, lastMessageReceivedDate: NSDate, type: ChatListType)
    {
        self.name = name
        self.jid = jid
        self.lastMessage = lastMessage
        self.lastMessageReceivedDate = lastMessageReceivedDate
        self.type = type
    }
    
    class func generateDate(jid: String) -> String
    {
        let chatOptions = NSUserDefaults.standardUserDefaults().objectForKey("chatOptions") as? [String: AnyObject]
        
        if chatOptions == nil {
            let curDate: String = DTLibs.convertStringFromDate("yyyy-MM-dd", date: NSDate())
            NSUserDefaults.standardUserDefaults().setObject(["lastDate": curDate, "lastID": 0], forKey: "chatOptions")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        // Compare Current Date and Last Date
        let cDate: NSDate = DTLibs.convertStringToDate("yyyy-MM-dd", date: DTLibs.convertStringFromDate("yyyy-MM-dd", date: NSDate()))
        println(NSUserDefaults.standardUserDefaults().objectForKey("chatOptions"))
        let lDate: NSDate = DTLibs.convertStringToDate("yyyy-MM-dd", date: (NSUserDefaults.standardUserDefaults().objectForKey("chatOptions") as [String: AnyObject])["lastDate"] as String)
        
        // Resetup Value
        if cDate.compare(lDate) == NSComparisonResult.OrderedDescending {
            NSUserDefaults.standardUserDefaults().setObject(["lastDate": DTLibs.convertStringFromDate("yyyy-MM-dd", date: cDate), "lastID": 1], forKey: "chatOptions")
        }else{
            var lastID = (NSUserDefaults.standardUserDefaults().objectForKey("chatOptions") as [String: AnyObject])["lastID"] as Int
            lastID++
            NSUserDefaults.standardUserDefaults().setObject(["lastDate": DTLibs.convertStringFromDate("yyyy-MM-dd", date: lDate), "lastID": lastID], forKey: "chatOptions")
        }
        
        NSUserDefaults.standardUserDefaults().synchronize()
        
        // Get Generated Value
        let date = DTLibs.convertStringFromDate("yyyyMMddHHmmss", date: NSDate())
        let id = (NSUserDefaults.standardUserDefaults().objectForKey("chatOptions") as [String: AnyObject])["lastID"] as Int
        
        return "\(jid)\(date)\(id)"
    }
    
}

enum ChatListType: Int {
    case Single = 1
    case Group = 2
}