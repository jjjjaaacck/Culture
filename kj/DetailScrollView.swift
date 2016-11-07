
import UIKit
import SwiftyJSON

class DetailScrollView: UIScrollView, UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.contentOffset.y + self.frame.height >= self.contentSize.height {
            return true
        }
        else {
            return false
        }
    }
}
