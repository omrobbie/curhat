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
    @IBOutlet weak var txtTitleEmpty: UILabel!
    @IBOutlet weak var viewEmpty: UIView!
    
    var curhats = [Curhat]()
    
    var db: Firestore?
    var curhatReference: CollectionReference?
    var curhatListerner: ListenerRegistration?
    
    deinit {
        curhatListerner?.remove()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Ubah warna Title Nav Bar
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Nunito-Regular", size: 20)!, NSAttributedStringKey.foregroundColor: UIColor.white
        ]
        
        self.tableViewCurhat.delegate = self
        self.tableViewCurhat.dataSource = self
        
        self.txtTitleEmpty.font = UIFont(name: "Nunito-Bold", size: 24.0) ?? UIFont.boldSystemFont(ofSize: 24.0)

        self.db = Firestore.firestore()
        
        self.curhatReference = db?.collection(CollectionPath.curhats)
        self.curhatListerner = curhatReference?.addSnapshotListener({ (querySnapshot, error) in
            guard let snapshot = querySnapshot else {return}
            
            self.viewEmpty.isHidden = snapshot.count > 0 ? true : false

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.CurhatComments,
            let destination = segue.destination as? CurhatCommentViewController,
            let index = tableViewCurhat.indexPathForSelectedRow?.row {
                destination.curhat = curhats[index]
        }
    }
    
    func addList(_ curhat: Curhat) {
        guard !self.curhats.contains(curhat) else {return}

        self.curhats.append(curhat)
        self.curhats.sort()
        
        guard let index = curhats.index(of: curhat) else {return}
        
        tableViewCurhat.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func updateList(_ curhat: Curhat) {
        guard let index = curhats.index(of: curhat) else {return}

        curhats[index] = curhat
        tableViewCurhat.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func removeList(_ curhat: Curhat) {
        guard let index = curhats.index(of: curhat) else {return}
        
        curhats.remove(at: index)
        tableViewCurhat.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
}

extension CurhatController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return curhats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewCurhat.dequeueReusableCell(withIdentifier: CellIdentifier.Curhat, for: indexPath) as! CurhatTableViewCell
        let qty = curhats[indexPath.row].comments
        let comment = "\(qty!) comment"

        cell.txtFeeling.text = curhats[indexPath.row].feeling
        cell.txtNickname.text = curhats[indexPath.row].nickname
        cell.txtComments.text = qty! > 0 ? comment + "s" : comment
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: SegueIdentifier.CurhatComments, sender: indexPath)
    }
}
