//
//  Login_ViewController.swift
//  kdip
//
//  Created by Rai on 12/22/14.
//  Copyright (c) 2014 rai. All rights reserved.
//

import UIKit
import Alamofire

class Login_ViewController: UIViewController, ChatDelegate {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var progressBar: UIProgressView!
    
    var progressCount: Float = 0
    var progressTotal: Float = 0
    
    var DelegateApp = UIApplication.sharedApplication().delegate as AppDelegate
    var isLoad = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DelegateApp.chatDelegate = self
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.isLoad = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doLogin(sender: AnyObject) {
        DelegateApp.onBeginLogin(self.username.text, password: self.password.text)
    }
    
    func chatDelegate(didLogin isLogin: Bool, isFirstInit: Bool, jid: String, name: String) {
        if isLogin {
            if isFirstInit {
                // Request VCard
                var fList = ChatConversation.getFriendList().getList()
                var iq = XMPPIQ()
                var vcard = DDXMLElement.elementWithName("vCard") as DDXMLElement
                if fList.count <= 0 {
                    self.performSegueWithIdentifier("showMainTab", sender: self)
                    return
                }
                self.progressTotal = Float(fList.count)
                self.progressCount = 0
                self.progressBar.setProgress(0, animated: false)
                self.progressBar.hidden = false
                for friends in fList
                {
                    println(friends.jid)
                    iq = XMPPIQ()
                    vcard = DDXMLElement.elementWithName("vCard") as DDXMLElement
                    iq.addAttributeWithName("from", stringValue: "\(jid)")
                    iq.addAttributeWithName("to", stringValue: "\(friends.jid)")
                    iq.addAttributeWithName("type", stringValue: "get")
                    iq.addAttributeWithName("id", stringValue: "requestvcard")
                    vcard.addAttributeWithName("xmlns", stringValue: "vcard-temp")
                    iq.addChild(vcard)
                    DelegateApp.xmppStream.sendElement(iq)
                }
                
            }else{
                if !isLoad {
                    isLoad = true
                    self.performSegueWithIdentifier("showMainTab", sender: self)
                }
            }
            
            
        }
    }
    
    func chatDelegate(friendId: String, friendName: String, friendAvatar: String) {
        self.progressCount++
        self.progressBar.setProgress((self.progressCount/self.progressTotal), animated: false)
        ChatConversation.UpdateFriend(friendId, fullname: friendName, avatar: friendAvatar)
        if self.progressCount >= self.progressTotal {
            self.performSegueWithIdentifier("showMainTab", sender: self)
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
