//
//  Comment.swift
//  ex
//
//  Created by omrobbie on 27/08/18.
//  Copyright © 2018 omrobbie. All rights reserved.
//

import FirebaseFirestore

struct CurhatComment {
    let id: String?
    let nickname: String?
    let comment: String?
    let sendDate: Date?
    
    init() {
        self.id = nil
        self.nickname = nil
        self.comment = nil
        self.sendDate = Date()
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard let nickname = data["nickname"] as? String else {return nil}
        guard let comment = data["comment"] as? String else {return nil}
        guard let sendDate = data["sendDate"] as? Date else {return nil}
        
        self.id = document.documentID
        self.nickname = nickname
        self.comment = comment
        self.sendDate = sendDate
    }
}

extension CurhatComment: DatabaseRepresentation {
    var representation: [String : Any] {
        var rep: [String : Any] = [
            "sendDate" : sendDate!,
            "nickname" : nickname!,
            "comment" : comment!
        ]
        
        if let id = self.id {
            rep["id"] = id
        }
        
        return rep
    }
}

extension CurhatComment: Comparable {
    static func == (lhs: CurhatComment, rhs: CurhatComment) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: CurhatComment, rhs: CurhatComment) -> Bool {
        return rhs.sendDate! < lhs.sendDate!
    }
}
