//
//  Curhat.swift
//  ex
//
//  Created by omrobbie on 26/08/18.
//  Copyright © 2018 omrobbie. All rights reserved.
//

import FirebaseFirestore

struct Curhat {
    let id: String?
    let nickname: String
    let feeling: String
    let comments: Int?
    
    init(nickname: String, feeling: String) {
        self.id = nil
        self.nickname = nickname
        self.feeling = feeling
        self.comments = 0
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard let nickname = data["nickname"] as? String else {return nil}
        guard let feeling = data["feeling"] as? String else {return nil}
        guard let comments = data["comments"] as? Int else {return nil}

        self.id = document.documentID
        self.nickname = nickname
        self.feeling = feeling
        self.comments = comments
    }
}

extension Curhat: DatabaseRepresentation {
    var representation: [String : Any] {
        var rep = ["nickname": nickname]
        
        if let id = self.id {
            rep["id"] = id
        }
        
        return rep
    }
}

extension Curhat: Comparable {
    static func == (lhs: Curhat, rhs: Curhat) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Curhat, rhs: Curhat) -> Bool {
        return lhs.nickname < rhs.nickname
    }
}
