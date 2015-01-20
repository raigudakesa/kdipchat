//
//  DataStore.swift
//  kdipchat
//
//  Created by Rai on 1/20/15.
//  Copyright (c) 2015 rai. All rights reserved.
//

import Foundation
class DataStore
{
    class var Shared : DataStore {
        struct Singleton {
            static let instance = DataStore()
        }
        return Singleton.instance
    }
    
    var database = FMDatabase(path: Util.getPath("kdip.sqlite"))
}
