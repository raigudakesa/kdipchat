//
//  FriendList_TableViewCell.swift
//  kdipchat
//
//  Created by Rai on 1/19/15.
//  Copyright (c) 2015 rai. All rights reserved.
//

import UIKit

class FriendList_TableViewCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
