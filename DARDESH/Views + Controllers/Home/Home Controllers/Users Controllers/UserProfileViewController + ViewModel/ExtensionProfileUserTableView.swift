//
//  ExtensionProfileUserTableView.swift
//  DARDESH
//
//  Created by Mohamed Ali on 10/07/2021.
//

import UIKit

extension ProfileUserTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 10.0
    }
}
