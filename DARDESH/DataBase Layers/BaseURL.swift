//
//  BaseURL.swift
//  DARDESH
//
//  Created by Mohamed Ali on 29/06/2021.
//

import Foundation
import FirebaseAuth

let imageFolder = "gs://dardesh-9e38a.appspot.com"
let defaultAvatar = "https://firebasestorage.googleapis.com/v0/b/dardesh-9e38a.appspot.com/o/Avatar%2Fef6bf4f05f3c28862e99881b0ff33430.jpg?alt=media&token=b6437458-7cf4-4e48-8a07-21b5bbbf5195"

let userCollection = "User"
let chatCollection = "Chat"
let messCollection = "Message"
let typingCollection = "Typing"

let currentUser = "UserData"
let RoomId = "chatRoomId"

let sentstatus = "sent"
let readstatus = "read"

let textType = "text"
let imageType = "image"
let videoType = "video"
let location = "location"
let audio = "audio"

var userID = Auth.auth().currentUser!.uid
