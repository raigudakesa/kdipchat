//
//  AppDelegate.swift
//  kdip
//
//  Created by Rai on 12/18/14.
//  Copyright (c) 2014 rai. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, XMPPStreamDelegate, XMPPRosterDelegate, XMPPOutgoingFileTransferDelegate {
    
    var chatDelegate: ChatDelegate?
    var chatListDelegate: ChatDelegate?
    var chatSingleDelegate: ChatDelegate?
    var customCertEvaluation: Bool = false
    
    var window: UIWindow?
    
    // XMPP Variables
    var xmppStream: XMPPStream!
    var xmppRoster: XMPPRoster!
    var xmppRosterStorage: XMPPRosterCoreDataStorage!
    
    var xmppReconnect: XMPPReconnect!
    var password: String = ""
    var isConnectionOpen: Bool = false
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        Util.copyFile("kdip.sqlite")
        self.onXMPPFirstInit()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // =========================================================
    // XMPP Receiver Module
    // =========================================================
    func onXMPPFirstInit()
    {
        self.xmppStream = XMPPStream()
        self.xmppReconnect = XMPPReconnect()
        self.xmppRosterStorage = XMPPRosterCoreDataStorage()
        self.xmppRoster = XMPPRoster(rosterStorage: self.xmppRosterStorage)
        self.xmppRoster.autoFetchRoster = true
        self.xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = true
        
        //Activate
        self.xmppReconnect.activate(xmppStream)
        self.xmppRoster.activate(xmppStream)
        
        //Delegate
        self.xmppStream.addDelegate(self, delegateQueue: dispatch_get_main_queue())
        self.xmppRoster.addDelegate(self, delegateQueue: dispatch_get_main_queue())
        
        //Server Configuration
        self.xmppStream.hostName = "vb.icbali.com"
        self.xmppStream.hostPort = 5222
        self.customCertEvaluation = true
    }
    
    func getJabberID()->String
    {
        return splitJabberId("\(self.xmppStream.myJID)")["fullJID"]!
    }
    
    func onBeginLogin(jabberID: String, password: String)
    {
        var error: NSError?
        var data: NSData?
        
        
        self.xmppStream.myJID = XMPPJID.jidWithString(jabberID+"/kdip")
        self.password = password
        self.xmppStream.connectWithTimeout(XMPPStreamTimeoutNone, error: &error)
    }
    
    func xmppStream(sender: XMPPStream!, willSecureWithSettings settings: NSMutableDictionary!) {
        settings.setObject(sender.myJID.domain, forKey: "kCFStreamSSLPeerName")
        if customCertEvaluation {
            settings.setObject(true, forKey: GCDAsyncSocketManuallyEvaluateTrust)
        }
    }
    
    func xmppStream(sender: XMPPStream!, didReceiveTrust trust: SecTrust!, completionHandler: ((Bool) -> Void)!) {
        completionHandler(true)
    }
    
    func xmppStreamDidConnect(sender: XMPPStream!) {
        var error: NSError?
        
        if xmppStream!.authenticateWithPassword(self.password, error: &error) {
            println("Authenticating...")
        }
        
    }
    
    func xmppStream(sender: XMPPStream!, didNotAuthenticate error: DDXMLElement!) {
        println("NOT AUTHENTICATE : \(error)")
        sender.disconnect()
    }
    
    func xmppStream(sender: XMPPStream!, didNotRegister error: DDXMLElement!) {
        println("NOT REGISTER : \(error)")
    }
    
    func xmppStreamDidAuthenticate(sender: XMPPStream!) {
        println("Authenticated")
        self.chatDelegate(didLogin: true, jid: "\(sender.myJID)", name: "\(sender.myJID)")
        
        // SET User Presence to Online
        var presence = XMPPPresence()
        var show = DDXMLElement.elementWithName("show") as DDXMLElement
        var status = DDXMLElement.elementWithName("status") as DDXMLElement
        show.setStringValue("chat")
        status.setStringValue("Available")
        presence.addChild(show)
        presence.addChild(status)
        xmppStream!.sendElement(presence)
        
        //Check Friend List
        let conversation = ChatConversation()
        let friendList = conversation.getFrientList()
        if friendList.getCount() <= 0 {
            var iq = XMPPIQ();
            var query = DDXMLElement.elementWithName("query") as DDXMLElement
            iq.addAttributeWithName("from", stringValue: "\(sender.myJID)")
            iq.addAttributeWithName("id", stringValue: "friendlistrequest")
            iq.addAttributeWithName("type", stringValue: "get")
            
            query.addAttributeWithName("xmlns", stringValue: "jabber:iq:roster")
            
            iq.addChild(query)
            xmppStream.sendElement(iq)
        }
        
        // Test VCard
//        var iq = XMPPIQ()
//        iq.addAttributeWithName("from", stringValue: "\(sender.myJID)")
//        iq.addAttributeWithName("type", stringValue: "get")
//        iq.addAttributeWithName("id", stringValue: "adit@vb.icbali.com")
//        var vcard = DDXMLElement.elementWithName("vcard") as DDXMLElement
//        vcard.addAttributeWithName("xmlns", stringValue: "vcard-temp")
//        iq.addChild(vcard)
//        xmppStream.sendElement(iq)
        
        // Test File Transfer
//        var filesend_queue = dispatch_queue_create("fileTransfer", nil)
//        var ft = XMPPOutgoingFileTransfer(dispatchQueue: filequeue)
//        var err:NSError?
//        ft.activate(xmppStream)
//        ft.addDelegate(self, delegateQueue: filesend_queue)
//        ft.sendData(NSData(base64EncodedString: imgdata, options: nil), named: "img.jpg", toRecipient: XMPPJID.jidWithString("adit@vb.icbali.com/iuvencas-iMac"), description: "Gambar Doang.", error: &err)
//        println(err)
    }
    
    func xmppStream(sender: XMPPStream!, didReceiveMessage message: XMPPMessage!) {
        let jid = splitJabberId("\(message.from())")["fullJID"]!
        let date = NSDate()
        let conversation = ChatConversation()
        println("RECV : \(message)")
        for children in message.children()
        {
            let mesg = message.elementForName(children.name)
            switch children.name
            {
            case "body":
                conversation.SaveMessage(jid: jid,
                    message: mesg.stringValue(),
                    date: date,
                    message_type: 1, message_status: 0)
                self.chatDelegate(jid, senderName: jid, didMessageReceived: mesg.stringValue(), date: date)
                break
            case "photo":
                let primary_id = ChatList.generateDate(jid)
                let thumb_url = mesg.attributeStringValueForName("thumb")
                let documentsDirectory = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
                let recvImagesDirectory = documentsDirectory[0].stringByAppendingPathComponent("receive_images")
                let fileManager = NSFileManager()
                var is_directory: ObjCBool = false
                if !fileManager.fileExistsAtPath(recvImagesDirectory, isDirectory: &is_directory) && !is_directory {
                    fileManager.createDirectoryAtPath(recvImagesDirectory, withIntermediateDirectories: false, attributes: nil, error: nil)
                }
                
                conversation.SaveMessage(primary_id: primary_id,
                    jid: jid,
                    message: "",
                    date: date,
                    message_type: 2,
                    message_status: 0,
                    multimedia_msgurl: mesg.stringValue(),
                    multimedia_msgthumburl: thumb_url)
                
                // Download File
                 Alamofire.download(.GET, "http://\(thumb_url!)", { (temporaryURL:NSURL, response: NSHTTPURLResponse) -> (NSURL) in
                    conversation.UpdateMessage(primary_id, message_status: 2, multimedia_msgthumblocal: "receive_images/\(response.suggestedFilename!)")
                    if let directoryURL = NSFileManager.defaultManager()
                        .URLsForDirectory(.DocumentDirectory,
                            inDomains: .UserDomainMask)[0]
                        as? NSURL {
                            let pathComponent = response.suggestedFilename
                            return directoryURL.URLByAppendingPathComponent("receive_images").URLByAppendingPathComponent(response.suggestedFilename!)
                    }
                    
                    return temporaryURL
                    
                })
                .responseJSON({ (temporaryURL, response, object, error) -> Void in
                    // =============================================================
                    let thumbnail_request = Alamofire.download(.GET, "http://\(mesg.stringValue())", { (temporaryURL:NSURL, response: NSHTTPURLResponse) -> (NSURL) in
                        conversation.UpdateMessage(primary_id, message_status: 2, multimedia_msglocal: "receive_images/\(response.suggestedFilename!)")
                        if let directoryURL = NSFileManager.defaultManager()
                            .URLsForDirectory(.DocumentDirectory,
                                inDomains: .UserDomainMask)[0]
                            as? NSURL {
                                let pathComponent = response.suggestedFilename
                                return directoryURL.URLByAppendingPathComponent("receive_images").URLByAppendingPathComponent(response.suggestedFilename!)
                        }
                        
                        return temporaryURL
                        
                    })
                    .responseJSON({ (temporaryURL, response, object, error) -> Void in
                            self.chatDelegate(jid, senderName: jid, didMultimediaReceived: mesg.stringValue(), date: date)
                            
                    })
                    .progress { (increment, current, total) -> Void in
                            println("\(current)/\(total)")
                    }
                    // =============================================================
                })
                
                break
            case "video":
                let primary_id = ChatList.generateDate(jid)
                let thumb_url = mesg.attributeStringValueForName("thumb")
                let documentsDirectory = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
                let recvImagesDirectory = documentsDirectory[0].stringByAppendingPathComponent("receive_videos")
                let fileManager = NSFileManager()
                var is_directory: ObjCBool = false
                if !fileManager.fileExistsAtPath(recvImagesDirectory, isDirectory: &is_directory) && !is_directory {
                    fileManager.createDirectoryAtPath(recvImagesDirectory, withIntermediateDirectories: false, attributes: nil, error: nil)
                }
                
                conversation.SaveMessage(primary_id: primary_id,
                    jid: jid,
                    message: "",
                    date: date,
                    message_type: 3,
                    message_status: 0,
                    multimedia_msgurl: mesg.stringValue(),
                    multimedia_msgthumburl: thumb_url)
                
                // Download File
                Alamofire.download(.GET, "http://\(thumb_url!)", { (temporaryURL:NSURL, response: NSHTTPURLResponse) -> (NSURL) in
                    conversation.UpdateMessage(primary_id, message_status: 2, multimedia_msgthumblocal: "receive_videos/\(response.suggestedFilename!)")
                    if let directoryURL = NSFileManager.defaultManager()
                        .URLsForDirectory(.DocumentDirectory,
                            inDomains: .UserDomainMask)[0]
                        as? NSURL {
                            let pathComponent = response.suggestedFilename
                            return directoryURL.URLByAppendingPathComponent("receive_videos").URLByAppendingPathComponent(response.suggestedFilename!)
                    }
                    
                    return temporaryURL
                    
                })
                .responseJSON({ (temporaryURL, response, object, error) -> Void in
                    self.chatDelegate(jid, senderName: jid, didMultimediaReceived: mesg.stringValue(), date: date)
                })
                break
            case "composing":
                self.chatDelegate(jid, senderName: jid, didReceiveChatState: 2)
                break
            case "paused":
                self.chatDelegate(jid, senderName: jid, didReceiveChatState: 1)
                break
            case "active":
                self.chatDelegate(jid, senderName: jid, didReceiveChatState: 0)
                break
            default:
                break
            }
        }

        
    }
    
    func xmppStream(sender: XMPPStream!, didSendMessage message: XMPPMessage!) {
        println("DIDSEND : \(message)")
        let conversation = ChatConversation()
        let date = NSDate()
        let jid = splitJabberId("\(message.to())")["fullJID"]!
        
        for children in message.children()
        {
            let mesg = message.elementForName(children.name);
            switch children.name
            {
            case "body":
                
                if mesg != nil {
                    
                    conversation.SaveMessage(jid: jid,
                        message: mesg.stringValue(),
                        date: date,
                        is_sender: true,
                        message_type: 1,
                        message_status: 0)
                    
                    self.chatDelegate(1, target: jid, didMessageSend: mesg.stringValue(), date: date)
                    
                }
                break
            case "photo", "video":
                let photo = message.elementForName(children.name);
                if photo != nil {
                    let messageId = message.attributeStringValueForName("id")
                    let conversation = ChatConversation()

                    conversation.UpdateMessage(messageId, message_status: 2)
                    self.chatDelegate(1, target: jid, didMessageSend: mesg.stringValue(), date: date)
                }
                break
            default:
                break
            }
        }
        
    }
    
    func splitJabberId(jid: String) -> [String:String]
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
    
    func xmppStream(sender: XMPPStream!, didReceivePresence presence: XMPPPresence!) {
        //println("Receive Presence : \(presence)")
        
        if presence.attributeStringValueForName("type") != nil {
            switch presence.attributeStringValueForName("type") {
            case "subscribe":
                self.xmppRoster.acceptPresenceSubscriptionRequestFrom(presence.from(), andAddToRoster: true)
            default:
                break;
            }
        }
    }
    
    func xmppStream(sender: XMPPStream!, didSendPresence presence: XMPPPresence!) {
        //println("Sended Presence : \(presence)")
    }
    
    func xmppRoster(sender: XMPPRoster!, didReceiveRosterItem item: DDXMLElement!) {
        //println("ROSTER ITEM: \(item)")
    }
    
    func xmppStream(sender: XMPPStream!, didReceiveIQ iq: XMPPIQ!) -> AnyObject! {
        println("IQ: \(iq)")
        return nil
    }
    
    func xmppStream(sender: XMPPStream!, didReceiveError error: DDXMLElement!) {
        println("ERROR : \(error)")
        for children in error.children()
        {
            switch children.name
            {
            case "conflict":
//                let alert = UIAlertController(title: "Warning", message: "Another devices logged in with this account", preferredStyle: UIAlertControllerStyle.Alert)
//                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//                self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
                
                break
            default:
                break
            }
        }
    }
    
    func xmppStreamDidDisconnect(sender: XMPPStream!, withError error: NSError!) {
        println("DISCONNECT : \(error)")
    }
    
    //==========================
    // Chat Delegate
    //==========================
    
    func chatDelegate(didAlertReceived alertCode: Int){
        
    }
    func chatDelegate(didBuddyListReceived buddylist: NSMutableArray) {
        self.chatDelegate?.chatDelegate?(didBuddyListReceived: buddylist)
    }
    func chatDelegate(didLogin isLogin: Bool, jid: String, name: String) {
        self.chatDelegate?.chatDelegate?(didLogin: isLogin, jid: jid, name: name)
    }
    func chatDelegate(senderId: String, senderName: String, didReceiveChatState state: Int) {
        self.chatSingleDelegate?.chatDelegate?(senderId, senderName: senderName, didReceiveChatState: state)
    }
    func chatDelegate(type: Int, target: String, didMessageSend message: String, date: NSDate) {
        self.chatListDelegate?.chatDelegate?(type, target: target, didMessageSend: message, date: date)
        self.chatSingleDelegate?.chatDelegate?(type, target: target, didMessageSend: message, date: date)
    }
    func chatDelegate(senderId: String, didMultimediaMessageSend data: String, messageId: String, date: NSDate) {
        self.chatListDelegate?.chatDelegate?(senderId, didMultimediaMessageSend: data, messageId: messageId, date: date)
        self.chatSingleDelegate?.chatDelegate?(senderId, didMultimediaMessageSend: data, messageId: messageId, date: date)
    }
    func chatDelegate(senderId: String, senderName: String, didMessageReceived message: String, date: NSDate) {
        self.chatListDelegate?.chatDelegate?(senderId, senderName: senderName, didMessageReceived: message, date: date)
        self.chatSingleDelegate?.chatDelegate?(senderId, senderName: senderName, didMessageReceived: message, date: date)
    }
    func chatDelegate(senderId: String, senderName: String, didMultimediaReceived data: String, date: NSDate) {
        self.chatListDelegate?.chatDelegate?(senderId, senderName: senderName, didMultimediaReceived: data, date: date)
        self.chatSingleDelegate?.chatDelegate?(senderId, senderName: senderName, didMultimediaReceived: data, date: date)
    }
    
    //==========================
    // File Transfer Section
    //==========================
    func xmppOutgoingFileTransferDidSucceed(sender: XMPPOutgoingFileTransfer!) {
        println("Success Transfering File")
    }
    
    func xmppOutgoingFileTransfer(sender: XMPPOutgoingFileTransfer!, didFailWithError error: NSError!) {
        println("Failed Transfering File")
    }

}

