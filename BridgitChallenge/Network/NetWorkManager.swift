//
//  NetWorkManager.swift
//  BridgitChallenge
//
//  Created by Nan Chen on 2017-11-15.
//  Copyright © 2017 Nan Chen. All rights reserved.
//

import Foundation
import Alamofire
import SWXMLHash
import CoreData

class NetWorkManager {

    func getFromServer(context: NSManagedObjectContext, callback: @escaping ()-> Void) {

        let url = "https://www.reddit.com/hot/.rss" 
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
                .responseString { response in

                    let xml = SWXMLHash.parse(response.data!)
                    
                    guard xml.children.count>0 else {
                        return
                    }

                    for elements in xml.children[0].children {

                        var values = [String: String]()

                        if (elements.children.count > 0) {
                            values.updateValue(elements.children[0].children[0].element!.text, forKey: "categoryLabel")
                        }
                        if (elements.children.count > 1) {
                            values.updateValue(elements.children[2].element!.text, forKey: "contentStr")

                            let regexp = ".*<img\\s+.*src\\s*=\\s*\"([^\"]+)\".*>.*"
                            let matched = self.capturedGroups(regexp, elements.children[2].element!.text)

                            if (matched.count > 0) {
                                values.updateValue(matched[0], forKey: "imgUrl")
                            }

                        }

                        if (elements.children.count > 2) {
                            values.updateValue(elements.children[3].element!.text, forKey: "id")
                        }

                        if (elements.children.count > 4) {
                            values.updateValue(elements.children[5].element!.text, forKey: "dateUpdated")
                        }

                        if (elements.children.count > 5) {
                            values.updateValue(elements.children[6].element!.text, forKey: "title")
                        }

                        if (values["id"] != nil) {

                            //saveItem
                            let helper = ParsedObjectHelper()
                            helper.saveItem(context: context, parsedValue: values)

                        }

                    }

                    DatabaseHelper.INSTANCE.saveContext(context: context)
                    
                    callback()
                }
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

}
