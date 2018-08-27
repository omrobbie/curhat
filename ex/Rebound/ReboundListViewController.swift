//
//  ReboundListViewController.swift
//  ex
//
//  Created by omrobbie on 27/08/18.
//  Copyright © 2018 omrobbie. All rights reserved.
//

import UIKit

class ReboundListViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableViewReboundList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableViewReboundList.delegate = self
        self.tableViewReboundList.dataSource = self
    }
}

extension ReboundListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewReboundList.dequeueReusableCell(withIdentifier: CellIdentifier.ReboundList, for: indexPath) as! ReboundListTableViewCell
        
        return cell
    }
}
