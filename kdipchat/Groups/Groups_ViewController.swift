//
//  Groups_ViewController.swift
//  kdipchat
//
//  Created by Rai on 1/21/15.
//  Copyright (c) 2015 rai. All rights reserved.
//

import UIKit

class Groups_ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ChatDelegate {
    var DelegateApp = UIApplication.sharedApplication().delegate as AppDelegate
    var groupList = [GroupList]()
    var selectedCell: NSIndexPath!
    
    @IBOutlet weak var btnTest: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.groupList = ChatConversation.getGroupList()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groupList.count
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
        let cell = tableView.dequeueReusableCellWithIdentifier("cellgroups", forIndexPath: indexPath) as Groups_TableViewCell
        cell.groupName.text = self.groupList[indexPath.row].name
        return cell
    }
    
    
    @IBAction func btn2Pressed(sender: UIButton) {
//        <presence
//        from='hag66@shakespeare.lit/pda'
//        id='n13mt3l'
//        to='coven@chat.shakespeare.lit/thirdwitch'>
//        <x xmlns='http://jabber.org/protocol/muc'>
//        <history seconds='180'/>
//        </x>
//        </presence>
        var presence = XMPPPresence()
        var x = DDXMLElement.elementWithName("x") as DDXMLElement
        var history = DDXMLElement.elementWithName("history") as DDXMLElement
        presence.addAttributeWithName("from", stringValue: DelegateApp.getJabberID())
        presence.addAttributeWithName("id", stringValue: "groupchathistory")
        presence.addAttributeWithName("to", stringValue: "room1@conference.vb.icbali.com/\(DelegateApp.getJabberName())")
        x.addAttributeWithName("xmlns", stringValue: "http://jabber.org/protocol/muc")
        history.addAttributeWithName("seconds", stringValue: "360")
        x.addChild(history)
        presence.addChild(x)
        DelegateApp.xmppStream.sendElement(presence)
    }
    @IBAction func btnPressed(sender: UIButton) {
        // Join to Room
        var presence = XMPPPresence()
        var x = DDXMLElement.elementWithName("x") as DDXMLElement
        var history = DDXMLElement.elementWithName("history") as DDXMLElement
        presence.addAttributeWithName("from", stringValue: DelegateApp.getJabberID())
        presence.addAttributeWithName("id", stringValue: "requestjoinroom")
        presence.addAttributeWithName("to", stringValue: "room1@conference.vb.icbali.com/\(DelegateApp.getJabberName())")
        x.addAttributeWithName("xmlns", stringValue: "http://jabber.org/protocol/muc")
        history.addAttributeWithName("seconds", stringValue: "60")
        x.addChild(history)
        presence.addChild(x)
        DelegateApp.xmppStream.sendElement(presence)
        
        
//        <iq from='hag66@shakespeare.lit/pda'
//        id='kl2fax27'
//        to='coven@chat.shakespeare.lit'
//        type='get'>
//        <query xmlns='http://jabber.org/protocol/disco#items'/>
//        </iq>
        
        // Example Query Available Room List
//        var iq = XMPPIQ()
//        var query = DDXMLElement.elementWithName("query") as DDXMLElement
//        iq.addAttributeWithName("from", stringValue: DelegateApp.getJabberID())
//        iq.addAttributeWithName("id", stringValue: "availableroom")
//        iq.addAttributeWithName("to", stringValue: "conference.vb.icbali.com")
//        iq.addAttributeWithName("type", stringValue: "get")
//        query.addAttributeWithName("xmlns", stringValue: "http://jabber.org/protocol/disco#items")
//        iq.addChild(query)
//        DelegateApp.xmppStream.sendElement(iq)
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
