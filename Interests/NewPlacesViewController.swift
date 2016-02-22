//
//  NewPlacesViewController.swift
//  interests
//
//  Created by 中川 智次郎 on 2016/02/15.
//  Copyright © 2016年 Developer Inspirus. All rights reserved.
//

import Foundation
import UIKit
import Photos
import Parse
import JavaScriptCore


class NewPlacesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var placeList: UITableView!
    
    // 5. テーブルに表示するテキスト
    let texts = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

    // テーブルに表示するアイテムの配列を用意
    var data: [AnyObject] = []
    
    private var businesses: [Business]!
    
    
    @IBAction func searchButton(sender: AnyObject) {
        let placename = placeName.text
        Business.searchWithTerm(placename!, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            print(businesses)
            
            for business in businesses {
                    self.data.append(business.url!)
                    print(business.url!)
                    print(business.name!)
                
            }
          print(self.data)
        })
        // 6. 必要なtableViewメソッド
        
        
    }

    
    
    override func viewDidLoad() {
        // 4. delegateとdataSourceを設定
        
        placeList.delegate = self
        placeList.dataSource = self
    }

    // 6. 必要なtableViewメソッド
    // セルの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return texts.count
    }
    
    // 6. 必要なtableViewメソッド
    // セルのテキストを追加
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = self.data[indexPath.row] as! String
        return cell
    }
    

        // 7. セルがタップされた時
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        print(texts[indexPath.row])
    }
    
    
    
}