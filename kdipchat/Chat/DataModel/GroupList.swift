//
//  GroupList.swift
//  kdipchat
//
//  Created by Rai on 1/22/15.
//  Copyright (c) 2015 rai. All rights reserved.
//

import Foundation

class GroupList {
    var group_id: String = ""
    var name: String = ""
    var total_user: Int = 0
    var is_admin: Int = 0
    var last_history_request: NSDate = NSDate()
    
    init()
    {
        
    }
    
    init(group_id: String, group_name: String, total_user: Int = 0, is_admin: Int = 0, last_history_request: NSDate = NSDate())
    {
        self.group_id = group_id
        self.name = group_name
        self.total_user = total_user
        self.is_admin = is_admin
        self.last_history_request = last_history_request
    }
}