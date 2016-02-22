//
//  Restaurant.swift
//  interests
//
//  Created by 中川 智次郎 on 2016/02/15.
//  Copyright © 2016年 Developer Inspirus. All rights reserved.
//

import Foundation

var resultQueryDictionary:NSDictionary!

class Resturant: NSObject {
    var name: String!
    var thumbUrl: String!
    var address: String!
    var jsonData: NSData!
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        thumbUrl = dictionary["thumbUrl"] as? String
        address = dictionary["address"] as? String
    }
    
    class func searchWithQuery(query: String, completion: ([Resturant]!, NSError!) -> Void) {
        YelpClient.sharedInstance.searchWithTerm(query, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let responseInfo = response as! NSDictionary
            resultQueryDictionary = responseInfo
            println(responseInfo)
            
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
        }
    }
    
}
