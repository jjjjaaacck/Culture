
import UIKit

class OptionAnimator: NSObject, UIViewControllerAnimatedTransitioning{
    
    let isPresenting: Bool
    
    init(isPresenting: Bool){
        
        self.isPresenting = isPresenting
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval{
        
        return 0.7
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        let bounds = UIScreen.main.bounds
        
        if isPresenting{
            let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!      //將進來的view controller
            
            let finalFrameForPresentVC = transitionContext.finalFrame(for: toViewController)
            
            toViewController.view.frame=finalFrameForPresentVC.offsetBy(dx: 0, dy: bounds.size.height)    //設定初始位置與大小
            
            containerView.addSubview(toViewController.view)
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: .curveLinear, animations: {
                toViewController.view.frame = finalFrameForPresentVC
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        }
        else {
            let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!      //將被覆蓋的view controller
            
            containerView.addSubview(fromViewController.view)
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.0, options: .curveLinear, animations: {
                fromViewController.view.frame = fromViewController.view.frame.offsetBy(dx: 0, dy: -bounds.size.height)
            }, completion: { (finished) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
}
