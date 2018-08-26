//
//  CurhatPostViewController.swift
//  ex
//
//  Created by omrobbie on 26/08/18.
//  Copyright © 2018 omrobbie. All rights reserved.
//

import UIKit

class CurhatPostViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var txtCurhat: UITextView!
    
    let placeholderText = "Type your feelings here.."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true

        self.txtCurhat.delegate = self
        self.txtCurhat.text = placeholderText
        self.txtCurhat.textColor = UIColor.lightGray
        
        let rightBarButton = UIBarButtonItem(title: "Post", style: UIBarButtonItemStyle.plain, target: self, action: #selector(postCurhat(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = UIColor.lightGray
        }
    }
    
    @objc func postCurhat(_ sender:UIBarButtonItem!) {
    }
}
