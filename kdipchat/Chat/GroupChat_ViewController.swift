//
//  GroupChat_ViewController.swift
//  kdipchat
//
//  Created by Rai on 1/22/15.
//  Copyright (c) 2015 rai. All rights reserved.
//

import UIKit

class GroupChat_ViewController: JSQMessagesViewController, ChatDelegate, UIScrollViewDelegate {
    var gallerypicker = UIImagePickerController()
    var msg = NSMutableArray()
    var tmpConversation = [ConversationData]()
    var DelegateApp = UIApplication.sharedApplication().delegate as AppDelegate
    var groupDisplayName = ""
    var groupId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DelegateApp.chatSingleDelegate = self
        
        self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
        self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
        
        self.showLoadEarlierMessagesHeader = false
        self.inputToolbar.contentView.leftBarButtonItem = nil
        self.automaticallyScrollsToMostRecentMessage = true
        
        self.reloadFromDatabase()
        // Do any additional setup after loading the view.
    }
    
    func reloadFromDatabase()
    {
        //Load Messages From Data Store
        self.msg = NSMutableArray()
        self.tmpConversation = ChatConversation.getConversationById(self.groupId)
        var usedSenderId: String!
        var usedSenderDN: String!
        for c in tmpConversation
        {
            usedSenderId = (c.is_sender == true) ? self.senderId : "\(c.jid)/\(c.group_id)"
            usedSenderDN = (c.is_sender == true) ? self.senderDisplayName : c.group_id
            
            if c.message_type == 1 {
                // Messages
                self.msg.addObject(JSQMessage(senderId: usedSenderId, senderDisplayName: usedSenderDN, date: c.message_date, text: c.message))
            }
        }
        
        self.collectionView.reloadData()
    }
    
    // ================================================================================
    // View of Chat Controller
    // ================================================================================
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        //return self.messages[indexPath.item]
        return self.msg.objectAtIndex(indexPath.item) as JSQMessageData
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return msg.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        var bubbleFactory = JSQMessagesBubbleImageFactory()
        
        if (msg.objectAtIndex(indexPath.item) as JSQMessage).senderId == self.senderId
        {
            
            return bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
        }
        
        return bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as JSQMessagesCollectionViewCell
        let message = msg.objectAtIndex(indexPath.item) as JSQMessage
        
        if (!message.isMediaMessage) {
            cell.textView.textColor = UIColor.blackColor()
        }
        
        return cell
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = msg.objectAtIndex(indexPath.item) as JSQMessage
        if indexPath.item < self.tmpConversation.count {
            if !self.tmpConversation[indexPath.item].is_sender{
                return NSAttributedString(string: message.senderDisplayName)
            }
        }
        return nil
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // =====================================================================
    // Chat Delegate
    // =====================================================================
    func chatDelegate(senderId: String, senderName: String, didMessageReceived message: String, date: NSDate) {
        let sid = "\(senderId)/\(senderName)"
        if  self.groupId == senderId {
            self.reloadFromDatabase()
            self.finishReceivingMessageAnimated(true)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
