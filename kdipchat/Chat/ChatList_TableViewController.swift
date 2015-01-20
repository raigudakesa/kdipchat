//
//  ChatList_TableViewController.swift
//  kdip
//
//  Created by Rai on 12/22/14.
//  Copyright (c) 2014 rai. All rights reserved.
//

import UIKit

class ChatList_TableViewController: UITableViewController, ChatDelegate {
    var DelegateApp = UIApplication.sharedApplication().delegate as AppDelegate
    
    var chatList = [ConversationData]()
    var selectedCell: NSIndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.DelegateApp.chatListDelegate = self
        
        loadChat()

    }
    
    func loadChat()
    {
        self.chatList = ChatConversation.getConversationList()
    }
    
    func chatDelegate(senderId: String, senderName: String, didMultimediaReceived data: String, date: NSDate) {
        self.loadChat()
        self.tableView.reloadData()
    }
    
    func chatDelegate(senderId: String, senderName: String, didMessageReceived message: String, date: NSDate) {
        self.loadChat()
        self.tableView.reloadData()
    }
    
    func chatDelegate(type: Int, target: String, didMessageSend message: String, date: NSDate) {
        self.loadChat()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return chatList.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 67
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedCell = indexPath
        performSegueWithIdentifier("showSingleChat", sender: self)
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellchatlist2", forIndexPath: indexPath) as ChatList_TableViewCell

        // Configure the cell..
//        cell.avatar.frame = CGRect(x: 15, y: 8, width: 50, height: 50)
//        cell.username.frame = CGRect(x: 73, y: 4, width: 180, height: 24)
//        cell.lastMessage.frame = CGRect(x: 73, y: 21, width: 180, height: 24)
//        cell.lastDate.frame = CGRect(x: 261, y: 4, width: 50, height: 24)
        
        // Set Cell Value
        cell.username.text = chatList[indexPath.row].name
        cell.lastMessage.text = (chatList[indexPath.row].message_type == 2) ? "[Picture]" : ((chatList[indexPath.row].message_type == 3) ? "[Video]" : chatList[indexPath.row].message)
        println(chatList[indexPath.row].message_date)
        cell.lastDate.text = formatNSDate("HH:mm", date: chatList[indexPath.row].message_date)

        return cell
    }
    
    func formatNSDate(format: String, date: NSDate) -> String
    {
        var formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = format
        let stringDate: String = formatter.stringFromDate(date)
        return stringDate
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier!
        {
        case "showSingleChat":
            let controller = segue.destinationViewController as SingleChat_ViewController
            controller.receiverDisplayName = chatList[self.selectedCell.row].name
            controller.receiverId = chatList[self.selectedCell.row].jid
            controller.senderId = DelegateApp.getJabberID()
            controller.senderDisplayName = DelegateApp.getJabberID()
            controller.navigationItem.title = chatList[self.selectedCell.row].name
            controller.hidesBottomBarWhenPushed = true
            break
        default:
            break
        }
    }


}
