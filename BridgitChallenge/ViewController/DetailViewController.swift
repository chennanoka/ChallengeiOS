//
//  DetailViewController.swift
//  BridgitChallenge
//
//  Created by Nan Chen on 2017-11-15.
//  Copyright © 2017 Nan Chen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
 
    var content:String = ""
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Detail"
        webView.loadHTMLString(content,baseURL: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
