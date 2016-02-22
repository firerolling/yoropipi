//
//  PlaceDetailViewController.swift
//  interests
//
//  Created by 株式会社ConU on 2016/02/19.
//  Copyright © 2016年 Developer Inspirus. All rights reserved.
//

import UIKit

class PlaceDetailViewController: UIViewController, UIWebViewDelegate {

   
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var gobackButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    
    
    
    var url = String()
    let titleLabel2 = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        titleLabel2.frame = CGRect(x: 10, y: 10, width: self.titleView.frame.width, height: 40)
        self.titleView.addSubview(titleLabel2)
        
        self.titleView.bringSubviewToFront(closeButton)
        self.titleLabel2.textColor = UIColor.whiteColor()
        
        let viewUrl: NSURL = NSURL(string: url)!
        let request: NSURLRequest = NSURLRequest(URL: viewUrl)
        webView.loadRequest(request)
        
        // Do any additional setup after loading the view.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil )
    }
    @IBAction func selectButtonTapped(sender: AnyObject) {
    }
    @IBAction func gobackTapped(sender: AnyObject) {
    }

    @IBAction func refreshTapped(sender: AnyObject) {
    }
    @IBOutlet weak var forwardTapped: UIButton!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
