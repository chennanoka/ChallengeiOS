//
//  HomeViewController.swift
//  BridgitChallenge
//
//  Created by Nan Chen on 2017-11-13.
//  Copyright © 2017 Nan Chen. All rights reserved.
//

import UIKit
import Alamofire
import SWXMLHash
import PINRemoteImage

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var homeTableView: UITableView!

    var parsedObjects: [ParsedObject] = []

    let helper = ParsedObjectHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.parent?.title = "Home"
        homeTableView.delegate = self
        homeTableView.dataSource = self
        retrieveData();
    }

    func retrieveData() {
        let manager = NetWorkManager()

        manager.getFromServer(context: DatabaseHelper.INSTANCE.getBackGroundContext(), callback: {
            DispatchQueue.main.async(execute: {
                self.parsedObjects = self.helper.fetchParsedItem(context: DatabaseHelper.INSTANCE.getViewContext())!
                self.homeTableView.reloadData()
            })
        })
    }

    func onSelectRow(index: Int) {
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailViewController.content = parsedObjects[index].contentStr ?? ""
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelectRow(index: indexPath.row)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parsedObjects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeTableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
        if indexPath.row < self.parsedObjects.count {
            let parsedObject = self.parsedObjects[indexPath.row]
            cell.title.text = parsedObject.title ?? ""

            if let date = parsedObject.dateUpdated {

                let regexp = "^(.+)T.*"
                let matched = self.capturedGroups(regexp, date)

                if (matched.count > 0) {
                    cell.date.text = matched[0]
                }
            }

            cell.category.text = parsedObject.categoryLabel ?? ""

            if (parsedObject.savedTime == nil || parsedObject.savedTime == "") {
                cell.star.setImage(UIImage(named: "unstar"), for: .normal)
            } else {
                cell.star.setImage(UIImage(named: "star"), for: .normal)
            }
            
            cell.star.tag = indexPath.row
            cell.star.addTarget(self, action: #selector(self.buttonPressed(_:)), for: .touchUpInside)

            if let imageURL = parsedObject.imgUrl, imageURL != "" {
                cell.thumbnail.pin_setImage(from: URL(string: imageURL)!)
            }

        }

        return cell
    }

    @objc func buttonPressed(_ sender : UIButton) {
        let button = sender
        let parsedObject = self.parsedObjects[button.tag]
        if (parsedObject.savedTime == nil || parsedObject.savedTime == "") {

            let date = NSDate()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: date as Date)
            parsedObject.savedTime = dateString
            helper.starItem(context: DatabaseHelper.INSTANCE.getViewContext(), parsedObject: parsedObject)
            button.setImage(UIImage(named: "star"), for: .normal)
        } else {

            parsedObject.savedTime = nil
            helper.unStarItem(context: DatabaseHelper.INSTANCE.getViewContext(), id: parsedObject.id!)
            button.setImage(UIImage(named: "unstar"), for: .normal)
        }
        retrieveData();
    }

    func capturedGroups(_ pattern: String, _ originalStr: String) -> [String] {
        var results = [String]()

        var regex: NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: pattern, options: [])
        } catch {
            return results
        }

        let matches = regex.matches(in: originalStr, options: [], range: NSRange(location: 0, length: originalStr.count))

        guard let match = matches.first else {
            return results
        }

        let lastRangeIndex = match.numberOfRanges - 1
        guard lastRangeIndex >= 1 else {
            return results
        }

        for i in 1...lastRangeIndex {
            let capturedGroupIndex = match.rangeAt(i)
            let matchedString = (originalStr as NSString).substring(with: capturedGroupIndex)
            results.append(matchedString)
        }

        return results
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
