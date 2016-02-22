//
//  ScrollViewController.swift
//  interests
//
//  Created by 株式会社ConU on 2016/02/15.
//  Copyright © 2016年 Developer Inspirus. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController {
    
    var interest = Interest()

    @IBOutlet weak var ThisScrollView: UIScrollView!
    override func viewDidLoad() {
        
        
        let vc1 = View1(nibName:"View1", bundle: nil)
        
        self.addChildViewController(vc1)
        self.ThisScrollView.addSubview(vc1.view)
        vc1.didMoveToParentViewController(self)
        
        
        let vc2 = View2(nibName:"View2", bundle: nil)
        
        
        var frame1 = vc2.view.frame
        frame1.origin.x = self.view.frame.size.width
        vc2.view.frame = frame1
        
        self.addChildViewController(vc2)
        self.ThisScrollView.addSubview(vc2.view)
        vc1.didMoveToParentViewController(self)
        
        // initialize Viewcontroller2
        let vc3 = View3(nibName:"View3", bundle: nil)
        
        var frame2 = vc3.view.frame
        frame2.origin.x = self.view.frame.size.width
        vc3.view.frame = frame2
        
        
        self.addChildViewController(vc3)
        self.ThisScrollView.addSubview(vc3.view)
        vc3.didMoveToParentViewController(self)
        
        
        self.ThisScrollView.contentSize = CGSizeMake(self.view.frame.size.width * 3, self.view.frame.size.height-66)
        

        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
