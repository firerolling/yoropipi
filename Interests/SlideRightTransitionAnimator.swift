//
//  SlideRightTransitionAnimator.swift
//  Interests
//
//  Created by Duc Tran on 6/15/15.
//  Copyright © 2015 Developer Inspirus. All rights reserved.
//

import UIKit

class SlideRightTransitionAnimator: NSObject
{
    var duration = 1.0
    private var isPresenting = false
}

extension SlideRightTransitionAnimator : UIViewControllerTransitioningDelegate
{
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresenting = false
        return self
    }
}

extension SlideRightTransitionAnimator : UIViewControllerAnimatedTransitioning
{
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval
    {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning)
    {
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        let containerView = transitionContext.containerView()!
        
        let offScreenLeft = CGAffineTransformMakeTranslation(-containerView.frame.width, 0)
        let minimize = CGAffineTransformMakeScale(0, 0)
        let shiftDown = CGAffineTransformMakeTranslation(0, 15)
        let scaleDown = CGAffineTransformScale(shiftDown, 0.8, 0.8)
        
        if isPresenting {
            let minimizeAndOffScreenLeft = CGAffineTransformConcat(minimize, offScreenLeft)
            toView.transform = minimizeAndOffScreenLeft
        }
        
        if isPresenting {
            containerView.addSubview(fromView)
            containerView.addSubview(toView)
        } else {
            containerView.addSubview(toView)
            containerView.addSubview(fromView)
        }
        
        // animate
        
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4, options: [], animations: { () -> Void in
            
            if self.isPresenting {
                
                fromView.transform = scaleDown
                fromView.alpha = 0.5
                toView.transform = CGAffineTransformIdentity
                
            } else {
                
                fromView.transform = offScreenLeft
                toView.alpha = 1.0
                toView.transform = CGAffineTransformIdentity
                
            }
            
            }) { (finished) -> Void in
                
                if finished {
                    transitionContext.completeTransition(true)
                }
        }
    }
}




























































