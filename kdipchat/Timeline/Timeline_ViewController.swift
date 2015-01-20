//
//  Timeline_ViewController.swift
//  kdip
//
//  Created by I Gusti Ngurah Aditya Dharma on 12/23/14.
//  Copyright (c) 2014 rai. All rights reserved.
//

import UIKit

class Timeline_ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var collectionView:UICollectionView?
    var flowLayout:UICollectionViewFlowLayout?
    var items:NSMutableArray?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        
        self.items = NSMutableArray()
        self.items?.addObjectsFromArray(["My Card"])
        
        let addBtn  = UIBarButtonItem (barButtonSystemItem: UIBarButtonSystemItem.Add,
            target: self,
            action: "addClicked")
        
        self.navigationItem.rightBarButtonItem = addBtn
        
        setupCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addClicked() {
        
        var alert = UIAlertView()
        alert.delegate = self
        alert.title = "Enter Input"
        alert.addButtonWithTitle("Done")
        alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
        alert.addButtonWithTitle("Cancel")
        alert.show()
    }
    
    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int)
    {
        
        if (buttonIndex == 0){
            
            let textField = alertView.textFieldAtIndex(0)
            
            self.collectionView?.performBatchUpdates({
                let resultsSize = self.items?.count
                self.items?.addObject(textField!.text)
                let size = resultsSize! + 1
                var arrayWithIndexPaths = NSMutableArray()
                var i = 0
                for (i = resultsSize!; i < resultsSize! + 1; i++) {
                    arrayWithIndexPaths.addObject(NSIndexPath(forRow: i, inSection: 0))
                }
                self.collectionView?.insertItemsAtIndexPaths(arrayWithIndexPaths)
                },
                completion: nil)
            
        }
        
        
        
    }
    
    
    func setupCollectionView(){
        self.flowLayout = UICollectionViewFlowLayout()
        self.flowLayout!.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: self.flowLayout!)
        self.collectionView!.delegate = self
        self.collectionView!.dataSource = self
        self.collectionView!.registerClass(Timeline_CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.collectionView!.backgroundColor = UIColor(red: 196/255, green: 196/255, blue: 196/255, alpha: 0.9)
        self.view.addSubview(self.collectionView!)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        return CGSizeMake((self.collectionView!.bounds.width - 20), 150)
        
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.items!.count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as Timeline_CollectionViewCell
        
        cell.setCardText(self.items![indexPath.row] as String)
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1).CGColor
//        cell.layer.cornerRadius = 4
        cell.backgroundColor = UIColor.whiteColor()
        
        return cell
        
        
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
