//
//  ChatsCell.swift
//  DARDESH
//
//  Created by Mohamed Ali on 19/07/2021.
//

import UIKit
import Kingfisher

class ChatsCell: UITableViewCell {
    
    @IBOutlet weak var UserProfileImageView: UIImageView!
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var LastMessageLabel: UILabel!
    @IBOutlet weak var LastMessageDateLabel: UILabel!
    @IBOutlet weak var UnReadedMessageCountLabel: UILabel!
    @IBOutlet weak var ContainerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        ContainerView.isHidden = true
        UserProfileImageView.MakeImageCircle()
        ContainerView.MakeViewCircle()
    }
    
    func ConfigureCell (_ chat: ChatModel) {
        
        DispatchQueue.main.async {
            self.UserProfileImageView.kf.setImage(with:URL(string: chat.AvatarLink))
        }
//        UserProfileImageView.image = UIImage(named: chat.AvatarLink)
        
        UserNameLabel.text = chat.RecevierName
        LastMessageLabel.text = chat.lastMessage
        
        if chat.unreadCounter != 0 {
            UnReadedMessageCountLabel.text = String(chat.unreadCounter)
            ContainerView.isHidden = false
        }
        else {
            ContainerView.isHidden = true
        }
        
        
        LastMessageDateLabel.text = chat.date?.timeElapsed() ?? Date().timeElapsed()
        
        
    }
    
}
