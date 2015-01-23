//
//  CreateGroup_ViewController.swift
//  kdipchat
//
//  Created by Rai on 1/23/15.
//  Copyright (c) 2015 rai. All rights reserved.
//

import UIKit

class CreateGroup_ViewController: UIViewController, ChatDelegate {

    @IBOutlet weak var textGroupName: UITextField!
    @IBOutlet weak var textGroupDescription: UITextField!
    var DelegateApp = UIApplication.sharedApplication().delegate as AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.DelegateApp.groupCreateDelegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createBtn(sender: UIBarButtonItem) {
        var roomid = self.textGroupName.text.stringByReplacingOccurrencesOfString(" ", withString: "").lowercaseString
        XmppUtility.requestCreateRoom(roomid)
    }
    
    func chatDelegate(roomid: String, affiliation: String, role: String, didRoomCreated created: Bool, error_code: Int) {
        if created {
            var is_admin = 0
            if affiliation == "owner" {
                is_admin = 1
            }
            ChatConversation.addGroups([GroupList(group_id: roomid, group_name: XmppUtility.splitJabberId(roomid)["accountName"]!, total_user: 50, is_admin: is_admin)])
            XmppUtility.setRoomConfiguration(roomid, roomname: self.textGroupName.text, roomdesc: self.textGroupDescription.text)
        }else{
            println("Room Creation Failed")
        }
    }
    
    func chatDelegate(roomid: String, didRoomUpdated updated: Bool) {
        if updated {
            ChatConversation.UpdateGroups(roomid, group_name: textGroupName.text)
            self.navigationController?.popViewControllerAnimated(true)
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
