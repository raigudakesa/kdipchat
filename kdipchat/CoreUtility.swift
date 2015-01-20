//
//  CoreUtility.swift
//  kdip
//
//  Created by Rai on 1/5/15.
//  Copyright (c) 2015 rai. All rights reserved.
//

import Foundation
import UIKit

class Util: NSObject {
    
    class func getPath(fileName: String) -> String {
        return NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0].stringByAppendingPathComponent(fileName)
    }
    
    class func copyFile(fileName: NSString) {
        var dbPath: String = getPath(fileName)
        var fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(dbPath) {
            var fromPath: String? = NSBundle.mainBundle().resourcePath?.stringByAppendingPathComponent(fileName)
            fileManager.copyItemAtPath(fromPath!, toPath: dbPath, error: nil)
        }
    }
    
    class func deleteFile(fileName: NSString) {
        var dbPath: String = getPath(fileName)
        var fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(dbPath) {
            fileManager.removeItemAtPath(dbPath, error: nil)
        }
    }
    
}