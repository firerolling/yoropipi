//
//  WebViewController.swift
//  interests
//
//  Created by 株式会社ConU on 2016/02/19.
//  Copyright © 2016年 Developer Inspirus. All rights reserved.
//

import UIKit

class WebViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    
    var urlString = "http://tabelog.com/"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.layer.cornerRadius = 20.0
        backButton.layer.masksToBounds = true
        forwardButton.layer.cornerRadius = 20.0
        forwardButton.layer.masksToBounds = true
        refreshButton.layer.masksToBounds = true
        refreshButton.layer.cornerRadius = 20.0
        
        
        webView.scrollView.bounces = false
        
        
        self.backButton.enabled = self.webView!.canGoBack
        // 次のページに進めるかどうか
        self.forwardButton.enabled = self.webView!.canGoForward
        self.refreshButton.enabled = false
        
        let url: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: url)
        webView.loadRequest(request)

        // Do any additional setup after loading the view.
    }
    
    // WebViewがコンテンツの読み込みを開始した時に呼ばれる
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        self.backButton.enabled = self.webView!.canGoBack
        self.forwardButton.enabled = self.webView!.canGoForward
        self.refreshButton.enabled = true
    }
    
    // WebView がコンテンツの読み込みを完了した後に呼ばれる
    func webViewDidFinishLoad(webView: UIWebView) {
        // インジケータを非表示にする
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        self.backButton.enabled = self.webView!.canGoBack
        self.forwardButton.enabled = self.webView!.canGoForward
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        self.webView?.goBack()
    }
    
    @IBAction func forwardButtonTapped(sender: AnyObject) {
        self.webView?.goForward()
    }
    @IBAction func refreshButtonTapped(sender: AnyObject) {
        self.webView?.reload()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    @IBAction func closeButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
   
    @IBAction func copyTapped(sender: AnyObject) {
    print(webView.stringByEvaluatingJavaScriptFromString("document.title"))
        //URLを出力
    print(webView.stringByEvaluatingJavaScriptFromString("document.URL")!)
    let title = webView.stringByEvaluatingJavaScriptFromString("document.title")!
    let url = webView.stringByEvaluatingJavaScriptFromString("document.URL")!
    
     NSNotificationCenter.defaultCenter().postNotificationName("URL", object: nil, userInfo: ["URL":url, "TITLE":title])
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
