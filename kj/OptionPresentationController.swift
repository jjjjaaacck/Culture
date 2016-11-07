import UIKit

class OptionPresentationController: UIPresentationController {
    
    lazy var layerView:UIView = {
        
        let view = UIView(frame: self.containerView!.bounds)
        
        view.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
        view.alpha = 0.0
        
        return view
    }()
    
    override func presentationTransitionWillBegin() {
        // Add the dimming view and the presented view to the heirarchy
        self.layerView.frame = self.containerView!.bounds
        
        self.containerView!.addSubview(self.layerView)
        
        self.containerView!.addSubview(self.presentedView!)
        
        // Fade in the dimming view alongside the transition
        if let transitionCoordinator = self.presentingViewController.transitionCoordinator {
            
            transitionCoordinator.animate(alongsideTransition: {(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
                
                self.layerView.alpha  = 1.0
                
                }, completion:nil)
        }
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool)  {
        
        // If the presentation didn't complete, remove the dimming view
        if !completed {
            
            self.layerView.removeFromSuperview()
            
        }
    }
    
    override func dismissalTransitionWillBegin()  {
        
        // Fade out the dimming view alongside the transition
        if let transitionCoordinator = self.presentingViewController.transitionCoordinator {
            
            transitionCoordinator.animate(alongsideTransition: {(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
                
                self.layerView.alpha  = 0.0
                
                }, completion:nil)
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        
        // If the dismissal completed, remove the dimming view
        if completed {
            
            self.layerView.removeFromSuperview()
            
        }
    }
    
    override var frameOfPresentedViewInContainerView : CGRect {
        
        // We don't want the presented view to fill the whole container view, so inset it's frame
        let container = self.containerView!.bounds;
        
        let frame = CGRect(x: 0, y: 0, width: container.width, height: container.height)
        
        return frame
    }
    
    override var presentedView : UIView? {
        let presentedView:UIView = self.presentedViewController.view
        presentedView.layer.cornerRadius=8.0
        presentedView.layer.masksToBounds = true
        
        return presentedView
    }
}
