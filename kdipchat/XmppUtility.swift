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
    
    class func getAvailableMUCService() -> String
    {
        return "conference.vb.icbali.com"
    }
    
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
    
    class func requestCreateRoom(roomid: String) -> Bool
    {
        if roomid == "" { return false }
        var DelegateApp = UIApplication.sharedApplication().delegate as AppDelegate
        var presence = XMPPPresence()
        var x = DDXMLElement.elementWithName("x") as DDXMLElement
        presence.addAttributeWithName("from", stringValue: DelegateApp.getJabberID())
        presence.addAttributeWithName("id", stringValue: "requestcreateroom")
        presence.addAttributeWithName("to", stringValue: "\(roomid)@\(XmppUtility.getAvailableMUCService())/\(DelegateApp.getJabberName())")
        x.addAttributeWithName("xmlns", stringValue: "http://jabber.org/protocol/muc")
        presence.addChild(x)
        DelegateApp.xmppStream.sendElement(presence)
        return true
    }
    
    class func requestRoomConfigurationField(fullroomid: String) -> Bool
    {
        if fullroomid == "" { return false }
        var DelegateApp = UIApplication.sharedApplication().delegate as AppDelegate
        var iq = XMPPIQ()
        var query = DDXMLElement.elementWithName("query") as DDXMLElement
        
        iq.addAttributeWithName("from", stringValue: DelegateApp.getJabberID())
        iq.addAttributeWithName("to", stringValue: "\(fullroomid)")
        iq.addAttributeWithName("id", stringValue: "requestconfigfield")
        iq.addAttributeWithName("type", stringValue: "get")
        query.addAttributeWithName("xmlns", stringValue: "http://jabber.org/protocol/muc#owner")
        iq.addChild(query)
        
        DelegateApp.xmppStream.sendElement(iq)
        return true
    }
    
    class func setRoomConfiguration(fullroomid: String, roomname: String, roomdesc: String) -> Bool
    {
        if fullroomid == "" || roomname == "" || roomdesc == "" { return false }
        
        var DelegateApp = UIApplication.sharedApplication().delegate as AppDelegate
        var iq = XMPPIQ()
        var query = DDXMLElement.elementWithName("query") as DDXMLElement
        var x = DDXMLElement.elementWithName("x") as DDXMLElement
        var field = DDXMLElement.elementWithName("field") as DDXMLElement
        var value = DDXMLElement.elementWithName("value") as DDXMLElement
        
        query.addAttributeWithName("xmlns", stringValue: "http://jabber.org/protocol/muc#owner")
        x.addAttributeWithName("xmlns", stringValue: "jabber:x:data")
        x.addAttributeWithName("type", stringValue: "submit")
        
        iq.addAttributeWithName("from", stringValue: DelegateApp.getJabberID())
        iq.addAttributeWithName("to", stringValue: "\(fullroomid)")
        iq.addAttributeWithName("id", stringValue: "setroomconfig")
        iq.addAttributeWithName("type", stringValue: "set")
        
        // Create Field
        field.addAttributeWithName("var", stringValue: "FORM_TYPE")
        value.setStringValue("http://jabber.org/protocol/muc#roomconfig")
        field.addChild(value)
        x.addChild(field)
        // ================ Room Name
        field.setAttributes([DDXMLNode.attributeWithName("var", stringValue: "muc#roomconfig_roomname")])
        field.children()[0].setStringValue(roomname)
        x.addChild(field.copy() as DDXMLNode)
        // ================ Room Description
        field.setAttributes([DDXMLNode.attributeWithName("var", stringValue: "muc#roomconfig_roomdesc")])
        field.children()[0].setStringValue(roomdesc)
        x.addChild(field.copy() as DDXMLNode)
        // ================ Make The Room Persistence
        field.setAttributes([DDXMLNode.attributeWithName("var", stringValue: "muc#roomconfig_persistentroom")])
        field.children()[0].setStringValue("1")
        x.addChild(field.copy() as DDXMLNode)
        // ================
        
        query.addChild(x)
        iq.addChild(query)

        DelegateApp.xmppStream.sendElement(iq)
        return true
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