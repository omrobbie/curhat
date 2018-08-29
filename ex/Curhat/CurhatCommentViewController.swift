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

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewCurhatComments: UITableView!
    @IBOutlet weak var txtComment: UITextField!
    @IBOutlet weak var txtNickname: UILabel!
    @IBOutlet weak var txtFeeling: UILabel!
    @IBOutlet weak var txtTitleEmpty: UILabel!
    @IBOutlet weak var viewEmpty: UIView!
    
    var curhat = Curhat()
    var curhatComments = [CurhatComment]()
    
    var db: Firestore?
    var curhatReference: CollectionReference?
    var curhatCommentsReference: CollectionReference?
    var curhatCommentsListerner: ListenerRegistration?
    
    deinit {
        curhatCommentsListerner?.remove()
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
        
        self.hideKeyboardWhenTappedAround()
        
        self.tabBarController?.tabBar.isHidden = true

        self.txtComment.delegate = self
        self.tableViewCurhatComments.delegate = self
        self.tableViewCurhatComments.dataSource = self
        
        self.txtNickname.text = self.curhat.nickname
        self.txtFeeling.text = self.curhat.feeling
        
        self.txtTitleEmpty.font = UIFont(name: "Nunito-Bold", size: 24.0) ?? UIFont.boldSystemFont(ofSize: 24.0)
        
        if NICKNAME?.isEmpty ?? true {
            changeNickname()
        }

        self.db = Firestore.firestore()
        self.curhatReference = db?.collection(CollectionPath.curhats)
        
        self.curhatCommentsReference = db?.collection([CollectionPath.curhats, self.curhat.id!, CollectionPath.comments].joined(separator: "/"))
        self.curhatCommentsListerner = curhatCommentsReference?.addSnapshotListener({ (querySnapshot, error) in
            guard let snapshot = querySnapshot else {return}
            
            self.viewEmpty.isHidden = snapshot.count > 0 ? true : false

            snapshot.documentChanges.forEach({ (documentChange) in
                guard let curhatComment = CurhatComment(document: documentChange.document) else {return}
            
                self.curhatReference?.document(self.curhat.id!).updateData([CollectionPath.comments : snapshot.count])
                
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
        if NICKNAME?.isEmpty ?? true {
            changeNickname()
            return
        }

        guard let comment = txtComment.text, txtComment.text != "" else {return}
        
        let docData: [String : Any] = [
            "nickname" : NICKNAME!,
            "comment" : comment,
            "sendDate" : Date()
        ]
        
        self.txtComment.text = ""
        self.curhatReference?.document(self.curhat.id!).collection(CollectionPath.comments).addDocument(data: docData)
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
    
    @objc func keyboardWasShown(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.bottomConstraint.constant = -(keyboardFrame.size.height - 34)
        })
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.bottomConstraint.constant = 0
        })
    }
}

extension CurhatCommentViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.btnSendClicked(self)
        return true
    }
}

extension CurhatCommentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return curhatComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewCurhatComments.dequeueReusableCell(withIdentifier: CellIdentifier.CurhatComment, for: indexPath) as! CurhatCommentTableViewCell
        
        cell.txtNickname.text = curhatComments[indexPath.row].nickname
        cell.txtComment.text = curhatComments[indexPath.row].comment
        
        return cell
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
