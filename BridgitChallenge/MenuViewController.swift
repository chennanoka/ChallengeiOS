//
//  MenuUIViewController.swift
//  BridgitChallenge
//
//  Created by Nan Chen on 2017-11-13.
//  Copyright © 2017 Nan Chen. All rights reserved.
//

import UIKit

protocol MenuViewControllerEvent{
    func onSelectRow(index:Int)
}
class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var delegate: MenuViewControllerEvent?
    
    let titleArray = ["Home","Labeled"]

    @IBOutlet weak var menuTableView: UITableView!
    
    var tableViewWidth:CGFloat?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menuTableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
        cell.titleLabel.text = titleArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.onSelectRow(index: indexPath.row)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        menuTableView.delegate = self
        menuTableView.dataSource = self
        tableViewWidth = menuTableView.frame.width
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
