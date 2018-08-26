//
//  CurhatCommentViewController.swift
//  ex
//
//  Created by omrobbie on 26/08/18.
//  Copyright © 2018 omrobbie. All rights reserved.
//

import UIKit
import FirebaseFirestore

class CurhatCommentViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableViewCurhatComments: UITableView!
    @IBOutlet weak var txtComment: UITextField!
    @IBOutlet weak var txtNickname: UILabel!
    @IBOutlet weak var txtFeeling: UILabel!
    
    var curhat = Curhat()
    var curhatComments = [CurhatComment]()
    
    var db: Firestore?
    
    var curhatReference: CollectionReference?
    var curhatCommentsReference: CollectionReference?
    var curhatCommentsListerner: ListenerRegistration?
    
    deinit {
        curhatCommentsListerner?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true

        self.tableViewCurhatComments.delegate = self
        self.tableViewCurhatComments.dataSource = self
        
        self.txtNickname.text = self.curhat.nickname
        self.txtFeeling.text = self.curhat.feeling
        
        self.db = Firestore.firestore()
        self.curhatReference = db?.collection("curhat")
        
        self.curhatCommentsReference = db?.collection(["curhat", self.curhat.id!, "comments"].joined(separator: "/"))
        self.curhatCommentsListerner = curhatCommentsReference?.addSnapshotListener({ (querySnapshot, error) in
            guard let snapshot = querySnapshot else {return}
            
            snapshot.documentChanges.forEach({ (documentChange) in
                guard let curhatComment = CurhatComment(document: documentChange.document) else {return}
                
                self.curhatReference?.document(self.curhat.id!).updateData(["comments" : snapshot.count])
                
                switch documentChange.type {
                case .added:
                    self.addList(curhatComment)
                    
                case .modified:
                    self.updateList(curhatComment)
                    
                case .removed:
                    self.removeList(curhatComment)
                }
            })
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func btnSendClicked(_ sender: Any) {
        guard let comment = txtComment.text, txtComment.text != "" else {return}
        
        let docData: [String : Any] = [
            "nickname" : "omrobbie",
            "comment" : comment
        ]
        
        self.curhatReference?.document(self.curhat.id!).collection("comments").addDocument(data: docData)
    }
    
    func addList(_ curhatComment: CurhatComment) {
        guard !self.curhatComments.contains(curhatComment) else {return}
        
        self.curhatComments.append(curhatComment)
        self.curhatComments.sort()
        
        guard let index = curhatComments.index(of: curhatComment) else {return}
        
        tableViewCurhatComments.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func updateList(_ curhatComment: CurhatComment) {
        guard let index = curhatComments.index(of: curhatComment) else {return}
        
        curhatComments[index] = curhatComment
        tableViewCurhatComments.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func removeList(_ curhatComment: CurhatComment) {
        guard let index = curhatComments.index(of: curhatComment) else {return}
        
        curhatComments.remove(at: index)
        tableViewCurhatComments.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
}

extension CurhatCommentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return curhatComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewCurhatComments.dequeueReusableCell(withIdentifier: "cellCurhatComment", for: indexPath) as! CurhatCommentTableViewCell
        
        cell.txtNickname.text = curhatComments[indexPath.row].nickname
        cell.txtComment.text = curhatComments[indexPath.row].comment
        
        return cell
    }
}
