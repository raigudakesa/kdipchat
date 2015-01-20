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
    
    func chatDelegate(didLogin isLogin: Bool, jid: String, name: String) {
        if isLogin {
            if !isLoad {
                isLoad = true
                self.performSegueWithIdentifier("showMainTab", sender: self)
            }
        }
    }
    
    func chatDelegate(didBuddyListReceived buddylist: NSMutableArray) {
        
    }
    
    func chatDelegate(didMessageReceived message: String) {
        
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
