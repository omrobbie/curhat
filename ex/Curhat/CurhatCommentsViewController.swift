//
//  CurhatCommentsViewController.swift
//  ex
//
//  Created by omrobbie on 26/08/18.
//  Copyright © 2018 omrobbie. All rights reserved.
//

import UIKit

class CurhatCommentsViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableViewCurhatComments: UITableView!
    @IBOutlet weak var txtComment: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true

        self.tableViewCurhatComments.delegate = self
        self.tableViewCurhatComments.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func btnSendClicked(_ sender: Any) {
    }
}

extension CurhatCommentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewCurhatComments.dequeueReusableCell(withIdentifier: "cellCurhatComments", for: indexPath) as! CurhatCommetsTableViewCell
        
        return cell
    }
}
