//
//  UsersCell.swift
//  DARDESH
//
//  Created by Mohamed Ali on 10/07/2021.
//

import UIKit
import Kingfisher

class UsersCell: UITableViewCell {
    
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var UserStatusLabel: UILabel!
    @IBOutlet weak var UserProfileImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        UserProfileImage.MakeImageCircle()
    }
    
    func ConfigureCell (User: UserModel) {
        UserNameLabel.text = User.UserName
        UserStatusLabel.text = User.status
        
        DispatchQueue.main.async {
            self.UserProfileImage.kf.setImage(with:URL(string: User.Image))
        }
    }
    
}
