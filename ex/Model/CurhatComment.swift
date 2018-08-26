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
    
    init() {
        self.id = nil
        self.nickname = nil
        self.comment = nil
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard let nickname = data["nickname"] as? String else {return nil}
        guard let comment = data["comment"] as? String else {return nil}
        
        self.id = document.documentID
        self.nickname = nickname
        self.comment = comment
    }
}

extension CurhatComment: DatabaseRepresentation {
    var representation: [String : Any] {
        var rep = ["nickname" : nickname!]
        
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
        return lhs.nickname! < rhs.nickname!
    }
}
