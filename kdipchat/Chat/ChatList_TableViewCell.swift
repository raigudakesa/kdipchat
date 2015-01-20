//
//  ChatList_TableViewCell.swift
//  kdip
//
//  Created by Rai on 12/22/14.
//  Copyright (c) 2014 rai. All rights reserved.
//

import UIKit

class ChatList_TableViewCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var lastMessage: UILabel!
    @IBOutlet weak var lastDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
