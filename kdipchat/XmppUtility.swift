//
//  XmppUtility.swift
//  kdipchat
//
//  Created by Rai on 1/20/15.
//  Copyright (c) 2015 rai. All rights reserved.
//

import Foundation

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
}