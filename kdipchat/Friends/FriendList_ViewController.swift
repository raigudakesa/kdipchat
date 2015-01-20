//
//  FriendList_ViewController.swift
//  kdipchat
//
//  Created by Rai on 1/19/15.
//  Copyright (c) 2015 rai. All rights reserved.
//

import UIKit

class FriendList_ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ChatDelegate {
    var DelegateApp = UIApplication.sharedApplication().delegate as AppDelegate
    var friendList = [FriendList]()
    var selectedCell: NSIndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.friendList = ChatConversation.getFriendList().getList()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friendList.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.selectedCell = indexPath
        performSegueWithIdentifier("showSingleChat", sender: self)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellfriendlist", forIndexPath: indexPath) as FriendList_TableViewCell
        cell.friendName.text = self.friendList[indexPath.row].name
        return cell
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier!
        {
        case "showSingleChat":
            let controller = segue.destinationViewController as SingleChat_ViewController
            controller.receiverDisplayName = friendList[self.selectedCell.row].name
            controller.receiverId = friendList[self.selectedCell.row].jid
            controller.senderId = DelegateApp.getJabberID()
            controller.senderDisplayName = DelegateApp.getJabberName()
            controller.navigationItem.title = friendList[self.selectedCell.row].name
            controller.hidesBottomBarWhenPushed = true
            break
        default:
            break
        }
    }


}
