//
//  ViewController.swift
//  BridgitChallenge/Users/nanchen/Documents/BridgitChallenge/BridgitChallenge/ViewController.swift
//
//  Created by Nan Chen on 2017-11-10.
//  Copyright © 2017 Nan Chen. All rights reserved.
//

import UIKit



enum CurrentViewType: Int {
    case home = 0, starred, detail
}

class RootViewController: UIViewController, MenuViewControllerEvent{
    var menuOpenStatus:Bool!
    var menuViewController:MenuViewController!
    var menuWidth:CGFloat!
    var currentPage:CurrentViewType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuViewController = self.storyboard?.instantiateViewController(withIdentifier:"MenuViewController") as! MenuViewController
        menuViewController.delegate = self
       
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = .right
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = .left
        
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
        

        showChild(self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController)
        
        menuOpenStatus = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func respondToSwipeGesture(gesture:UISwipeGestureRecognizer){
        if gesture.state == .recognized {
            switch gesture.direction {
            case .right:
                showMenu()
            case .left:
                hideMenu()
            default:break
            }
        }
    }
    
    
    
    func showMenu()
    {
        menuOpenStatus = true 
        self.view.addSubview(self.menuViewController.view)
        menuWidth = menuViewController.tableViewWidth ?? 0
    
        self.menuViewController.view.frame = CGRect(x:-self.menuWidth, y:self.navigationController!.navigationBar.frame.height, width:UIScreen.main.bounds.size.width+self.menuWidth, height: UIScreen.main.bounds.size.height)
        
        UIView.animate(withDuration: 0.5) {
            self.menuViewController.view.frame = CGRect(x:0, y:self.navigationController!.navigationBar.frame.height, width:UIScreen.main.bounds.size.width+self.menuWidth, height: UIScreen.main.bounds.size.height)
            self.menuViewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        }
     
    }
    
    func hideMenu()
    {
        menuOpenStatus = false
        if(self.menuWidth != nil){
        UIView.animate(withDuration: 0.5, animations: {
            self.menuViewController.view.frame = CGRect(x:-self.menuWidth, y:self.navigationController!.navigationBar.frame.height, width:UIScreen.main.bounds.size.width+self.menuWidth, height: UIScreen.main.bounds.size.height)
              self.menuViewController.view.backgroundColor = UIColor.white.withAlphaComponent(0)
        }) { (result) in
             self.menuViewController.view.removeFromSuperview()
        }
        }
    }

    @IBAction func menu(_ sender: UIBarButtonItem) {
        if menuOpenStatus{
            hideMenu()
        }else{
            showMenu()
        }
    }
    
    func onSelectRow(index:Int){
        if(currentPage.rawValue != index){
            switch index {
            case CurrentViewType.home.rawValue:
                showChild(self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController)
            case CurrentViewType.starred.rawValue:
                showChild(self.storyboard?.instantiateViewController(withIdentifier: "StarredViewController") as! StarredViewController)
            default:
                showChild(self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController)
            }
        }
        hideMenu()
    }
    
    func showChild(_ viewController:UIViewController){
        if viewController is HomeViewController {
            currentPage = CurrentViewType.home
        } else if viewController is StarredViewController {
            currentPage = CurrentViewType.starred
        } else {
            currentPage = CurrentViewType.home
        }
        
        for uiviewController:UIViewController in self.childViewControllers{
            uiviewController.willMove(toParentViewController: nil)
            uiviewController.view.removeFromSuperview()
            uiviewController.removeFromParentViewController()
        }
        self.addChildViewController(viewController)
        self.view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParentViewController:self)
    }
}

