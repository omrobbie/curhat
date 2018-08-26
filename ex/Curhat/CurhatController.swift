//
//  CurhatController.swift
//  ex
//
//  Created by omrobbie on 10/08/18.
//  Copyright © 2018 omrobbie. All rights reserved.
//

import UIKit
import FirebaseFirestore

class CurhatController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableViewCurhat: UITableView!
    
    let db = Firestore.firestore()
    
    var curhats = [Curhat]()
    
    var curhatListerner: ListenerRegistration?
    var curhatReference: CollectionReference {
        return db.collection("curhat")
    }
    
    deinit {
        curhatListerner?.remove()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableViewCurhat.delegate = self
        self.tableViewCurhat.dataSource = self
        
        curhatListerner = curhatReference.addSnapshotListener({ (querySnapshot, error) in
            guard let snapshot = querySnapshot else {return}
            
            snapshot.documentChanges.forEach({ (documentChange) in
                guard let curhat = Curhat(document: documentChange.document) else {return}
                
                switch documentChange.type {
                case .added:
                    self.addList(curhat)
                    
                case .modified:
                    self.updateList(curhat)
                    
                case .removed:
                    self.removeList(curhat)
                }
            })
        })
    }
    
    func addList(_ curhat: Curhat) {
//        guard !self.curhats.contains(curhat) else {return}
//
//        self.curhats.append(curhat)
//        self.curhats.sort()
    }
    
    func updateList(_ curhat: Curhat) {
//        guard let index = curhats.index(of: curhat) else {return}
//
//        curhats[index] = curhat
//        tableViewCurhat.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func removeList(_ curhat: Curhat) {
        
    }
}

extension CurhatController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewCurhat.dequeueReusableCell(withIdentifier: "cellCurhat", for: indexPath) as! CurhatTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "CurhatComments", sender: indexPath)
    }
}
