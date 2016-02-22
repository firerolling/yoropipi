//
//  NewPlaceViewController.swift
//  interests
//
//  Created by 株式会社ConU on 2016/02/16.
//  Copyright © 2016年 Developer Inspirus. All rights reserved.
//

import UIKit
import Parse


class NewPlaceViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var placeField: UITextField!
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    
    var interest: Interest!
    // MARK: - Properties
   
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var ikkyuButton: UIButton!
    @IBOutlet weak var gurunaviButton: UIButton!
    @IBOutlet weak var tabelogButton: UIButton!
   
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
   
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeField.delegate = self
        urlField.delegate = self
        
        placeField.layer.borderColor = UIColor(hex: "#36D7B7").CGColor
        placeField.font = UIFont(name: "Avenir", size: 22)
        placeField.textColor = UIColor(hex: "#36D7B7")
        
        urlField.layer.borderColor = UIColor(hex: "#36D7B7").CGColor
        urlField.font = UIFont(name: "Avenir", size: 22)
        urlField.textColor = UIColor(hex: "#36D7B7")
        
        closeButton.layer.cornerRadius = 20.0
        closeButton.layer.masksToBounds = true
        
        addButton.backgroundColor = UIColor(hex: "#36D7B7")
        addButton.layer.cornerRadius = 35.0
        addButton.layer.masksToBounds = true
        
        googleButton.layer.cornerRadius = 30.0
        googleButton.layer.masksToBounds = true
        ikkyuButton.layer.cornerRadius = 30.0
        ikkyuButton.layer.masksToBounds = true
        tabelogButton.layer.cornerRadius = 30.0
        tabelogButton.layer.masksToBounds = true
        gurunaviButton.layer.cornerRadius = 30.0
        gurunaviButton.layer.masksToBounds = true

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "urlPaste:", name: "URL", object: nil)
        
    }
    
    func urlPaste(notification: NSNotification?){
        if let userInfo = notification?.userInfo {
            let url = userInfo["URL"]! as! String
            print(url)
            self.urlField.text = url
            
            let title = userInfo["TITLE"]! as! String
            self.placeField.text = title
            
        }
        print("あい")

    }
    
    
    
    @IBAction func sendPlace(sender: UIButton) {
        
        if placeField.text!.isEmpty {
            let alertView = SCLAlertView()
            alertView.addButton("OK"){print("tapped")}
            alertView.showCloseButton = false
            alertView.showSuccess("Oops!", subTitle: "You must fill place name.")

            
        }else{
        
        uploadNewPlace()
        self.dismissViewControllerAnimated(true, completion: nil)
                    }
        
        
    }
    
    @IBAction func closeButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true , completion: nil)
    }
    
    
    
    
    func uploadNewPlace() {
        let new = placeField.text
        let newUrl = urlField.text
        let newPlace = Place(user: PFUser.currentUser()!, placeText: new!, placeUrl: newUrl!, numberOfLikes: 0, interestId: interest.objectId!,  isSelected: false)
        newPlace.saveInBackgroundWithBlock { (success, error) -> Void in
            if error == nil {
                self.interest.incrementNumberOfPlaces()
            } else {
                print("\(error?.localizedDescription)")
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        placeField.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: 40)
        placeField.placeholder = "PLACE NAME"
        urlField.frame = CGRect(x: 0, y: 170, width: self.view.frame.width, height: 40)
        urlField.placeholder = "URL"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "tabelog" {
            let secondView: WebViewController = segue.destinationViewController as! WebViewController
            secondView.urlString = "http://tabelog.com/"
        } else if segue.identifier == "gurunavi" {
            let secondView: WebViewController = segue.destinationViewController as! WebViewController
            secondView.urlString = "http://www.gnavi.co.jp/"
        } else if segue.identifier == "google" {
            let secondView: WebViewController = segue.destinationViewController as! WebViewController
            secondView.urlString = "https://www.google.co.jp/?gws_rd=ssl"
        } else if segue.identifier == "ikkyu" {
            let secondView: WebViewController = segue.destinationViewController as! WebViewController
            secondView.urlString = "http://www.ikyu.com/"
        }
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        placeField.resignFirstResponder()
        urlField.resignFirstResponder()
        return true
    }

}


