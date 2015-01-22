//
//  ChatConversation.swift
//  kdip
//
//  Created by Rai on 1/5/15.
//  Copyright (c) 2015 rai. All rights reserved.
//

import Foundation

class ChatConversation {
    
    class func clearDataStore()
    {
        DataStore.Shared.database!.open()
        var resultset = DataStore.Shared.database?.executeUpdate("DELETE FROM friend_list", withArgumentsInArray: nil)
        DataStore.Shared.database?.close()
    }
    
    // Friends =================================================
    class func getFriendList() -> FriendListResult
    {
        DataStore.Shared.database!.open()
        var resultset = DataStore.Shared.database?.executeQuery("SELECT * FROM friend_list ORDER BY fullname ASC", withArgumentsInArray: nil)
        var fl = [FriendList]()
        var jname = ""
        while resultset!.next()
        {
            if resultset!.stringForColumn("fullname")? != nil && resultset!.stringForColumn("fullname") != "" {
                jname = resultset!.stringForColumn("fullname")
            }else{
                jname = XmppUtility.splitJabberId(resultset!.stringForColumn("jid"))["accountName"]!
            }
            fl.append(FriendList(jid: resultset!.stringForColumn("jid"),
                fullname: jname,
                avatar: resultset!.stringForColumn("avatar"),
                avatar_tmp: resultset!.stringForColumn("avatar_tmp"),
                avatar_tmpthumb: resultset!.stringForColumn("avatar_tmpthumb"),
                lastdate: DTLibs.convertStringToDate("yyyy-MM-dd HH:mm:ss", date: resultset!.stringForColumn("last_update"))))
        }
        DataStore.Shared.database?.close()
        
        return FriendListResult(result: fl)
    }
    
    class func UpdateFriend(jid: String, fullname:String = "", avatar: String = "", avatar_tmpthumb: String = "", avatar_tmp: String = "", status:String = "", last_update: NSDate = NSDate())
    {
        DataStore.Shared.database!.open()
        var resultset = DataStore.Shared.database?.executeUpdate("UPDATE friend_list SET fullname=?, avatar=?, avatar_tmpthumb=?, avatar_tmp=?, status=?, last_update=? WHERE jid=?", withArgumentsInArray: [fullname, avatar, avatar_tmpthumb, avatar_tmp, status, DTLibs.convertStringFromDate("yyyy-MM-dd HH:mm:ss", date: last_update), jid])
        DataStore.Shared.database?.close()
    }
    
    class func addFriendList(friendList: [FriendList])
    {
        if friendList.count <= 0 { return }
        
        DataStore.Shared.database!.open()
        var template = "INSERT INTO friend_list VALUES "
        var sql = ""
        var strDate = ""
        for fl in friendList
        {
            strDate = DTLibs.convertStringFromDate("yyyy-MM-dd HH:mm:ss", date: fl.date)
            sql = sql + template + "('\(fl.jid)','\(fl.name)','\(fl.avatar)','\(fl.avatar_tmpthumb)','\(fl.avatar_tmp)','\(fl.status)','\(strDate)'); "
        }
        DataStore.Shared.database?.executeStatements(sql)
        DataStore.Shared.database?.close()
    }
    // ========================================================================================
    
    // GROUPS
    class func getGroupList() -> [GroupList]
    {
        DataStore.Shared.database!.open()
        var resultset = DataStore.Shared.database?.executeQuery("SELECT * FROM group_list ORDER BY group_name ASC", withArgumentsInArray: nil)
        var gl = [GroupList]()
        var gname = ""
        while resultset!.next()
        {
            gl.append(GroupList(group_id: resultset!.stringForColumn("group_id"),
                group_name: resultset!.stringForColumn("group_name"),
                total_user: resultset!.longForColumn("total_user"),
                is_admin: resultset!.longForColumn("is_admin"),
                last_history_request: DTLibs.convertStringToDate("yyyy-MM-dd HH:mm:ss", date: resultset!.stringForColumn("last_history_request"))))
            
        }
        DataStore.Shared.database?.close()
        
        return gl
    }
    
    class func UpdateGroups(group_id: String, group_name: String = "", total_user: Int = -1, is_admin: Int = -1, last_history_request: NSDate? = NSDate())
    {
        DataStore.Shared.database!.open()
        var lhr = "";
        var set = (group_name == "") ? "" : ", group_name = '\(group_name)'"
        if last_history_request != nil {
            lhr = DTLibs.convertStringFromDate("yyyy-MM-dd HH:mm:ss", date: last_history_request!)
        }
        set = set + ((total_user == -1) ? "" : ", total_user = '\(total_user)'")
        set = set + ((is_admin == -1) ? "" : ", is_admin = '\(is_admin)'")
        set = set + ((last_history_request == nil) ? "" : ", last_history_request = '\(lhr)'")
        if set != "" { set = set.substringFromIndex(advance(set.startIndex, 1)) }
        var resultset = DataStore.Shared.database?.executeUpdate("UPDATE group_list SET \(set) WHERE group_id=?", withArgumentsInArray: [group_id])
        DataStore.Shared.database?.close()
    }
    
    class func addGroups(groupList: [GroupList])
    {
        if groupList.count <= 0 { return }
        
        DataStore.Shared.database!.open()
        var template = "INSERT INTO group_list VALUES "
        var sql = ""
        var strDate = ""
        for gl in groupList
        {
            strDate = DTLibs.convertStringFromDate("yyyy-MM-dd HH:mm:ss", date: gl.last_history_request)
            sql = sql + template + "('\(gl.group_id)','\(gl.name)','\(gl.total_user)','\(gl.is_admin)','\(strDate)'); "
        }
        DataStore.Shared.database?.executeStatements(sql)
        DataStore.Shared.database?.close()
    }
    
    // ========================================================================================
    
    class func getConversationList() -> [ConversationData]
    {
        var chatList = [ConversationData]()
        DataStore.Shared.database!.open()
        var resultset = DataStore.Shared.database?.executeQuery("SELECT chat_conversation.*,friend_list.fullname FROM chat_conversation LEFT JOIN friend_list ON friend_list.jid = chat_conversation.jid GROUP BY jid ORDER BY date DESC", withArgumentsInArray: nil)
        var jname = ""
        while resultset!.next() {
            if resultset!.stringForColumn("group_id") != "-1"
            {
                jname = XmppUtility.splitJabberId(resultset!.stringForColumn("jid"))["accountName"]!
            }else{
                if resultset!.stringForColumn("fullname")? != nil && resultset!.stringForColumn("fullname") != "" {
                    jname = resultset!.stringForColumn("fullname")
                }else{
                    jname = XmppUtility.splitJabberId(resultset!.stringForColumn("jid"))["accountName"]!
                }
            }
            
            chatList.append(ConversationData(jid: resultset!.stringForColumn("jid"),
                name: jname,
                group_id: resultset!.stringForColumn("group_id"),
                is_sender: resultset!.boolForColumn("is_sender"),
                message_id: resultset!.stringForColumn("primary_id"),
                message: resultset!.stringForColumn("message"),
                message_multimediaurl: resultset!.stringForColumn("multimediamsg_fileurl"),
                message_multimedialocal: resultset!.stringForColumn("multimediamsg_filelocal"),
                message_multimediathumburl: resultset!.stringForColumn("multimediamsg_filethumburl"),
                message_multimediathumblocal: resultset!.stringForColumn("multimediamsg_filethumblocal"),
                message_date: DTLibs.convertStringToDate("yyyy-MM-dd HH:mm:ss", date: resultset!.stringForColumn("date")),
                message_type: resultset!.longForColumn("message_type"),
                message_status: resultset!.longForColumn("message_status")))
            //chatList.append(ChatList(jid: resultset!.stringForColumn("jid"), name: resultset!.stringForColumn("jid"), lastMessage: resultset!.stringForColumn("message"), lastMessageReceivedDate: NSDate(), type: ChatListType.Single))
        }
        DataStore.Shared.database?.close()
        return chatList
    }
    
    class func getConversationById(jid: String, group_id: String = "-1") -> [ConversationData]
    {
        var conversation = [ConversationData]()
        DataStore.Shared.database!.open()
        var resultset = DataStore.Shared.database?.executeQuery("SELECT a.*,b.fullname FROM chat_conversation AS a LEFT JOIN friend_list AS b ON b.jid = a.jid WHERE a.jid=? ORDER BY a.date ASC", withArgumentsInArray: [jid, group_id])
        var jname = ""
        
        while resultset!.next() {
           
            if resultset!.stringForColumn("fullname")? != nil && resultset!.stringForColumn("fullname") != "" {
                jname = resultset!.stringForColumn("fullname")
            }else{
                jname = XmppUtility.splitJabberId(resultset!.stringForColumn("jid"))["accountName"]!
            }
            conversation.append(ConversationData(jid: resultset!.stringForColumn("jid"),
                name: jname,
                group_id: resultset!.stringForColumn("group_id"),
                is_sender: resultset!.boolForColumn("is_sender"),
                message_id: resultset!.stringForColumn("primary_id"),
                message: resultset!.stringForColumn("message"),
                message_multimediaurl: resultset!.stringForColumn("multimediamsg_fileurl"),
                message_multimedialocal: resultset!.stringForColumn("multimediamsg_filelocal"),
                message_multimediathumburl: resultset!.stringForColumn("multimediamsg_filethumburl"),
                message_multimediathumblocal: resultset!.stringForColumn("multimediamsg_filethumblocal"),
                message_date: DTLibs.convertStringToDate("yyyy-MM-dd HH:mm:ss", date: resultset!.stringForColumn("date")),
                message_type: resultset!.longForColumn("message_type"),
                message_status: resultset!.longForColumn("message_status")))
        }
        DataStore.Shared.database?.close()
        return conversation
    }
    
    class func SaveMessage(primary_id:String = "", jid: String, group_id: String = "-1", message: String, date: NSDate, is_sender: Bool = false, message_type: Int = 1, message_status: Int, multimedia_msgurl: String = "", multimedia_msglocal:String = "", multimedia_msgthumburl:String = "", multimedia_msgthumblocal:String = "")
    {
        //Message Type
        //1: Message Only
        //2: Multimedia Message
        //3: Multimedia Message With Text
        DataStore.Shared.database!.open()
        
        var primary_id = primary_id
        if primary_id == "" { primary_id = ChatList.generateDate(jid) }
        var resultinsert = DataStore.Shared.database?.executeUpdate("INSERT INTO chat_conversation VALUES(?,?,?,?,?,?,?,?,?,?,?,?)",
            withArgumentsInArray: [primary_id, DTLibs.convertStringFromDate("yyyy-MM-dd HH:mm:ss", date: date), jid, group_id, is_sender, message, multimedia_msgurl, multimedia_msglocal, multimedia_msgthumburl, multimedia_msgthumblocal, message_type, message_status])
        DataStore.Shared.database?.close()
    }
    
    class func UpdateMessage(primary_id:String, message_status: Int, multimedia_msgurl: String = "", multimedia_msglocal:String = "",
                       multimedia_msgthumburl: String = "", multimedia_msgthumblocal:String = "")
    {
        DataStore.Shared.database!.open()
        var mmurl = (multimedia_msgurl == "") ? "" : ", multimediamsg_fileurl = '\(multimedia_msgurl)'"
        var mmlocal = (multimedia_msglocal == "") ? "" : ", multimediamsg_filelocal = '\(multimedia_msglocal)'"
        var mmturl = (multimedia_msgthumburl == "") ? "" : ", multimediamsg_filethumburl = '\(multimedia_msgthumburl)'"
        var mmtlocal = (multimedia_msgthumblocal == "") ? "" : ", multimediamsg_filethumblocal = '\(multimedia_msgthumblocal)'"
        var resultinsert = DataStore.Shared.database?.executeUpdate("UPDATE chat_conversation SET message_status=?\(mmurl)\(mmlocal)\(mmturl)\(mmtlocal) WHERE primary_id=?",
            withArgumentsInArray: [message_status, primary_id])
        DataStore.Shared.database?.close()
    }
    
}

class FriendListResult {
    private var fl = [FriendList]()
    
    init(result: [FriendList])
    {
        self.fl = result
    }
    
    func getCount() -> Int!
    {
        return fl.count
    }
    
    func getList() -> [FriendList]
    {
        return fl
    }
}