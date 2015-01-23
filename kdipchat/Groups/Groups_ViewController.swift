//
//  Groups_ViewController.swift
//  kdipchat
//
//  Created by Rai on 1/21/15.
//  Copyright (c) 2015 rai. All rights reserved.
//

import UIKit

class Groups_ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate, ChatDelegate {
    var DelegateApp = UIApplication.sharedApplication().delegate as AppDelegate
    var groupList = [GroupList]()
    var selectedCell: NSIndexPath!
    var searchController: UISearchDisplayController!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.groupList = ChatConversation.getGroupList()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.groupList = ChatConversation.getGroupList()
        self.tableView.reloadData()
    }

    @IBAction func searchGroup(sender: UIBarButtonItem) {
        var theSearchBar = UISearchBar(frame: CGRectMake(0, 0, 320, 40))
        theSearchBar.delegate = self;

        theSearchBar.placeholder = "Search Here"
        theSearchBar.showsCancelButton = true
        
        self.tableView.tableHeaderView = theSearchBar
        
        self.searchController = UISearchDisplayController(searchBar: theSearchBar, contentsController: self)

        searchController.delegate = self
        searchController.searchResultsDataSource = self
        searchController.searchResultsDelegate = self
        
        searchController.setActive(true, animated: true)
        theSearchBar.becomeFirstResponder()
    }
    
    @IBAction func createGroup(sender: UIBarButtonItem) {
        
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
        performSegueWithIdentifier("showGroupChat", sender: self)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellgroups",forIndexPath: indexPath) as Groups_TableViewCell
        cell.groupName.text = self.groupList[indexPath.row].name
        return cell
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier!
        {
        case "showGroupChat":
            let controller = segue.destinationViewController as GroupChat_ViewController
            controller.groupDisplayName = XmppUtility.splitJabberId(groupList[self.selectedCell.row].group_id)["accountName"]!
            controller.groupId = groupList[self.selectedCell.row].group_id
            controller.senderId = DelegateApp.getJabberID()
            controller.senderDisplayName = DelegateApp.getJabberName()
            controller.navigationItem.title = XmppUtility.splitJabberId(groupList[self.selectedCell.row].group_id)["accountName"]!
            controller.hidesBottomBarWhenPushed = true
            break
        default:
            break
        }
    }

}
