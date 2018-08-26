//
//  CurhatController.swift
//  ex
//
//  Created by omrobbie on 10/08/18.
//  Copyright © 2018 omrobbie. All rights reserved.
//

import UIKit

class CurhatController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableViewCurhat: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableViewCurhat.delegate = self
        self.tableViewCurhat.dataSource = self
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
