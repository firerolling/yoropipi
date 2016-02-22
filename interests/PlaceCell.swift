//
//  PlaceCell.swift
//  interests
//
//  Created by 株式会社ConU on 2016/02/16.
//  Copyright © 2016年 Developer Inspirus. All rights reserved.
//

import UIKit
import Parse

protocol PlaceCellDelegate
{
    func commentButtonClicked(place: Place)
}

class PlaceCell: UITableViewCell {
    
    
    var place: Place! {
        didSet {
            updateUI()
        }
    }
    
    var delegate: PlaceCellDelegate!
    
    
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    @IBOutlet weak var mask: UIView!
    
    let placeLikeLabel = UILabel()
    
    
    let button = DOFavoriteButton(frame: CGRectMake(0, 0, 70, 70), image: UIImage(named: "like"))
    
    
    //オーナー専用ボタン
    let selectButton = UIButton()
    let selectIcon = UIImage(named: "decision")
    
    
    let selectedIcon = UIImageView()

    
    
    
    private func updateUI() {
        placeLabel.text = place.placeText
        
        placeLikeLabel.text = "\(place.numberOfLikes)"
        
        urlLabel.text = place.placeUrl
        
        
        //        let user:String = "\(PFUser.currentUser()?.objectId)"
        //        print(user)
        
        let user = PFUser.currentUser()
        let currentUserId = user?.objectId
        let array:[String] = place.likedUserIds
        print(array)
        let index = array.indexOf(currentUserId!)
        print(index)
        
        if (index != nil) {
            button.select()
        } else {
            print("おされてない")
            button.deselect()
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didTapButton:", name: "PLACEBUTTON2", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "redeside:", name: "PLACEDESIDE2", object: nil)

        

    }
    
    func didTapButton(sender: UIButton!) {
        
        self.button.removeFromSuperview()
        self.addSubview(selectButton)
        self.bringSubviewToFront(selectButton)
        place.saveInBackground()
        NSNotificationCenter.defaultCenter().postNotificationName("placedeselect", object: nil)
        
        
    }
    
    
    func redeside(sender: UIButton!){
        place.isSelected = false
        place.saveInBackground()
        NSNotificationCenter.defaultCenter().postNotificationName("placeredesidetapped", object: nil)
        mask.layer.borderColor = UIColor(hex: "#36D7B7").CGColor
        mask.layer.borderWidth = 2.0
        mask.layer.cornerRadius = 10.0
        mask.backgroundColor = UIColor.whiteColor()
        selectButton.alpha = 0.5
        placeLabel.textColor = UIColor(hex: "#36D7B7")
        placeIcon.tintColor = UIColor(hex: "#36D7B7")
        diamond.removeFromSuperview()
        self.selectedIcon.removeFromSuperview()
        self.addSubview(button)
        
        
    }
    
    func selectedView() {
        self.button.removeFromSuperview()
        self.selectButton.removeFromSuperview()
        if place.isSelected == true {
            self.addSubview(selectedIcon)
            mask.layer.borderColor = UIColor(hex: "#F89406").CGColor
            mask.backgroundColor = UIColor(hex: "#F89406")
            self.placeIcon.tintColor = UIColor.whiteColor()
            self.placeLikeLabel.backgroundColor = UIColor.whiteColor()
            self.placeLikeLabel.textColor = UIColor(hex: "#F89406")
            self.placeLabel.textColor = UIColor.whiteColor()
            self.urlLabel.textColor = UIColor.whiteColor()
        }
    }

    
    
    func tapped(sender: DOFavoriteButton) {
        
        
        if currentUserLikes() {
            place.dislike()
            sender.deselect()
            
        }else{
            place.like()
            sender.select()
        }
        
        placeLikeLabel.text = "\(place.numberOfLikes)"
    }
    
    func mostLiked() {
        mask.layer.borderColor = UIColor(hex: "#36D7B7").CGColor
        mask.backgroundColor = UIColor(hex: "#36D7B7")
        placeIcon.tintColor = UIColor.whiteColor()
        placeLabel.textColor = UIColor.whiteColor()
        urlLabel.textColor = UIColor.whiteColor()
        self.addSubview(diamond)
        
    }
    
    let placeIcon = UIImageView(image: UIImage(named: "place")?.imageWithRenderingMode(.AlwaysTemplate))
    let diamond = UIImageView(image: UIImage(named: "diamond")?.imageWithRenderingMode(.AlwaysTemplate))
    
    func currentUserLikes() -> Bool {
        if let ids = place.likedUserIds {
            if ids.contains(User.currentUser()!.objectId!) {
                return true
            }
        }
        return false
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        

        
        placeLabel.textColor = UIColor(hex: "#36D7B7")
        urlLabel.textColor = UIColor(hex: "#36D7B7")
        
        mask.layer.borderColor = UIColor(hex: "#36D7B7").CGColor
        mask.layer.borderWidth = 2.0
        mask.layer.cornerRadius = 10.0
        
        placeIcon.tintColor = UIColor(hex: "#36D7B7")
        placeIcon.frame = CGRect(x: 15, y: 25, width: 50, height: 50)
        
        
        diamond.frame = CGRect(x: 55, y: 15, width: 20, height: 20)
        diamond.alpha = 0.8
        let angle:CGFloat = CGFloat((30.0 * M_PI) / 180.0)
        diamond.transform = CGAffineTransformMakeRotation(angle)
        
        diamond.tintColor = UIColor.whiteColor()
        
        
        
        button.addTarget(self, action: Selector("tapped:"), forControlEvents: .TouchUpInside)
        
        button.imageColorOff = UIColor(hex: "#bdc3c7")
        button.imageColorOn = UIColor(hex: "#F89406")
        button.duration = 2.0 // default: 1.0
        button.circleColor = UIColor(hex: "#F89406")
        button.lineColor = UIColor(hex: "#F89406")
        
        button.frame = CGRect(x: 330, y: 15, width: 50, height: 50)
        
        
        placeLikeLabel.text = "0"
        placeLikeLabel.backgroundColor = UIColor(hex: "#F89406")
        placeLikeLabel.layer.cornerRadius = 12.5
        placeLikeLabel.frame = CGRect(x: 15, y: 20, width: 25, height: 25)
        placeLikeLabel.layer.masksToBounds = true
        placeLikeLabel.textAlignment = .Center
        placeLikeLabel.textColor = UIColor.whiteColor()
        
        selectButton.setImage(selectIcon, forState: .Normal)
        selectButton.frame = CGRect(x: 340, y: 15, width: 60*50/60, height: 76*50/60)
        selectButton.alpha = 0.5
        selectButton.transform = CGAffineTransformMakeRotation(angle)
        selectButton.addTarget(self, action: "selected:", forControlEvents: .TouchUpInside)
        
        selectedIcon.image = selectIcon
        selectedIcon.frame = CGRect(x: 340, y: 15, width: 60*50/60, height: 76*50/60)
        selectedIcon.transform = CGAffineTransformMakeRotation(angle)

        
        
        self.addSubview(placeIcon)
        self.addSubview(button)
        self.addSubview(placeLikeLabel)
        
    }
    
    
    func selected(sender: UIButton){
        
        let alertView = SCLAlertView()
        alertView.addButton("SELECT"){ self.selectDate() }
        alertView.addButton("CENCEL"){
            self.cancelDate()
            
        }
        
        alertView.showCloseButton = false
        alertView.showSuccess("Select This Date?", subTitle: "")
        
    }
    
    func selectDate() {
        print("select")
        self.selectButton.alpha = 1.0
        self.mask.backgroundColor = UIColor(hex: "#F89406")
        self.mask.layer.borderColor = UIColor(hex: "#F89406").CGColor
        place.isSelected = true
        place.saveInBackground()
        NSNotificationCenter.defaultCenter().postNotificationName("SELECTPLACE", object: nil, userInfo: ["selectplace":place.placeText])
        
    }
    
    func cancelDate() {
        print("cancel")
    }
    

    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
