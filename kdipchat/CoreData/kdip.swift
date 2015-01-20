//
//  kdip.swift
//  kdip
//
//  Created by Rai on 12/23/14.
//  Copyright (c) 2014 rai. All rights reserved.
//

import Foundation
import CoreData

class kdip: NSManagedObject {

    @NSManaged var avatar: String
    @NSManaged var fullname: String
    @NSManaged var jid: String
    @NSManaged var status: String

}
