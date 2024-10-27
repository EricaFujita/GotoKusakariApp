//
//  ChatRoom.swift
//  GotoKusakariAPP
//
//  Created by madoka suzuki on 2023/04/13.
//

import Foundation
import Firebase
class ChatRoom{
    let lastmessageid:String
    let members:[String]
    let createdAtTime:Timestamp
    var partneruser:User?
    var documentid:String?
    var lastmessage:Message?
    init(dic:[String:Any]){
        self.lastmessageid = dic["lastmessageid"]as? String ?? ""
        self.members = dic["members"]as? [String] ?? [String]()
        self.createdAtTime = dic["createdAtTime"]as? Timestamp ?? Timestamp()
    }
}
