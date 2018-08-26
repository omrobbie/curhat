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
    
    init(nickname: String, feeling: String) {
        self.id = nil
        self.nickname = nickname
        self.feeling = feeling
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard let nickname = data["nickname"] as? String else {return nil}
        guard let feeling = data["feeling"] as? String else {return nil}
        
        self.id = document.documentID
        self.nickname = nickname
        self.feeling = feeling
    }
}

extension Curhat: DatabaseRepresentation {
    var representation: [String: Any] {
        var rep = ["nickname": self.nickname]
        
        if let id = self.id {
            rep["id"] = id
        }
        
        return rep
    }
}
