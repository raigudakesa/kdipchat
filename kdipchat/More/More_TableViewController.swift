//
//  More_TableViewController.swift
//  kdipchat
//
//  Created by Rai on 1/23/15.
//  Copyright (c) 2015 rai. All rights reserved.
//

import UIKit

class More_TableViewController: UITableViewController, UIScrollViewDelegate {
    private let kTableHeaderHeight: CGFloat = 250.0
    private let kTableHeaderCutAway: CGFloat = 80.0
    var headerView: UIView!
    var headerMaskLayer: CAShapeLayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view, typically from a nib.
        
        self.headerMaskLayer = CAShapeLayer()
        self.headerMaskLayer.fillColor = UIColor.blackColor().CGColor
        
        self.headerView = self.tableView.tableHeaderView
        self.headerView.layer.mask = self.headerMaskLayer
        
        self.tableView.tableHeaderView = nil
        self.tableView.addSubview(self.headerView)
    
    //self.tableView.contentInset = UIEdgeInsets(top: self.kTableHeaderHeight, left: 0, bottom: 0, right: 0)
        //self.tableView.contentOffset = CGPoint(x: 0, y: -self.kTableHeaderHeight)
        
        let effectiveHeight = self.kTableHeaderHeight-kTableHeaderCutAway/2
        self.tableView.contentInset = UIEdgeInsets(top: effectiveHeight, left: 0, bottom: 0, right: 0)
        self.tableView.contentOffset = CGPoint(x: 0, y: -effectiveHeight)
        
        self.updateHeaderView()
    }
    
    func updateHeaderView()
    {
        let effectiveHeight = self.kTableHeaderHeight-kTableHeaderCutAway/2
        //var headerRect = CGRect(x: 0, y: -self.kTableHeaderHeight, width: self.tableView.bounds.width, height: self.kTableHeaderHeight)
        var headerRect = CGRect(x: 0, y: -effectiveHeight, width: self.tableView.bounds.width, height: self.kTableHeaderHeight)
        let path = UIBezierPath()
        
        if self.tableView.contentOffset.y < -effectiveHeight {
            headerRect.origin.y = self.tableView.contentOffset.y
            headerRect.size.height = -self.tableView.contentOffset.y+kTableHeaderCutAway/2
        }
        
        //Create Path
        path.moveToPoint(CGPoint(x: 0, y: 0))
        path.addLineToPoint(CGPoint(x: headerRect.width, y: 0))
        path.addLineToPoint(CGPoint(x: headerRect.width, y: headerRect.height))
        path.addLineToPoint(CGPoint(x: 0, y: headerRect.height-self.kTableHeaderCutAway))
        
        self.headerMaskLayer?.path = path.CGPath
        
        self.headerView.frame = headerRect
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        self.updateHeaderView()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        return cell
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}
