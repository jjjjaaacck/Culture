//
//  InteractionController.swift
//  kj
//
//  Created by 劉 on 2015/7/30.
//  Copyright (c) 2015年 劉. All rights reserved.
//

import UIKit

class InteractionController: UIPercentDrivenInteractiveTransition {
    
    var presentingVC: UIViewController!
    var shouldCompleteTransition = false
    var transitionInProgress = false
    var panGestureRecognizer:UIPanGestureRecognizer!
    
    func attachToViewController(_ viewController: UIViewController) {
        presentingVC = viewController
        setupGestureRecognizer(presentingVC.view)
    }
    
    fileprivate func setupGestureRecognizer(_ view: UIView) {
        panGestureRecognizer=UIPanGestureRecognizer(target: self, action: #selector(InteractionController.handlePanGesture(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        let viewTranslation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        switch gestureRecognizer.state {
        case .began:
        
            transitionInProgress = true
            presentingVC.dismiss(animated: true, completion: nil)
        
        case .changed:
        
            let const = CGFloat(fminf(fmaxf(Float(viewTranslation.y / -800.0), 0.0), 1.0))
            shouldCompleteTransition = const > 0.13
            update(const)

        case .cancelled, .ended:
        
            transitionInProgress = false
            if !shouldCompleteTransition || gestureRecognizer.state == .cancelled {
                cancel()
            }
            else {
                finish()
            }
      
        default: break
        
        }
    }
}
