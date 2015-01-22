//
//  XmppUtility.swift
//  kdipchat
//
//  Created by Rai on 1/20/15.
//  Copyright (c) 2015 rai. All rights reserved.
//

import Foundation
import UIKit

class XmppUtility {
    
    class func splitJabberId(jid: String) -> [String:String]
    {
        var splitJid = split(jid) {$0 == "/"}
        var splitAccount = split(splitJid[0]) {$0 == "@"}
        var resource = ""
        if splitJid.count > 1 {
            resource = splitJid[1]
        }
        if splitAccount.count > 1 {
            return ["fullJID": splitJid[0], "accountName":splitAccount[0], "hostname":splitAccount[splitAccount.count-1], "resource":resource]
        }
        return ["fullJID": splitJid[0], "accountName":splitAccount[0], "hostname":splitAccount[1], "resource":resource]
    }
    
    class func joinAllAvailableGroup() {
        var DelegateApp = UIApplication.sharedApplication().delegate as AppDelegate
        let groupList = ChatConversation.getGroupList()
        var presence = XMPPPresence()
        var x = DDXMLElement.elementWithName("x") as DDXMLElement
        var history = DDXMLElement.elementWithName("history") as DDXMLElement
        
        if groupList.count > 0
        {
            for group in groupList
            {
                let timenow = NSDate()
                let timediff = timenow.timeIntervalSinceDate(group.last_history_request)
                presence = XMPPPresence()
                x = DDXMLElement.elementWithName("x") as DDXMLElement
                history = DDXMLElement.elementWithName("history") as DDXMLElement
                
                presence.addAttributeWithName("from", stringValue: DelegateApp.getJabberID())
                presence.addAttributeWithName("id", stringValue: "requestjoinroom")
                presence.addAttributeWithName("to", stringValue: "\(group.group_id)/\(DelegateApp.getJabberName())")
                x.addAttributeWithName("xmlns", stringValue: "http://jabber.org/protocol/muc")
                history.addAttributeWithName("seconds", stringValue: "\(Int(timediff))")
                x.addChild(history)
                presence.addChild(x)
                println(presence)
                DelegateApp.xmppStream.sendElement(presence)
            }
            
        }
        
        
    }
}