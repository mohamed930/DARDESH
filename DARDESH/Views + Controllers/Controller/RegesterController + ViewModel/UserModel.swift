//
//  UserModel.swift
//  DARDESH
//
//  Created by Mohamed Ali on 30/06/2021.
//

import Foundation
import FirebaseFirestoreSwift

struct UserModel: Codable {
    var uid: String
    var email: String
    var UserName: String
    var Image: String
    var status: String
    var pushid = ""
}
