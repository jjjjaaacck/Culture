import UIKit

class WebViewController:  UIViewController, UIWebViewDelegate{
    
    @IBOutlet weak var previousButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var webView: UIWebView!
    @IBAction func previousPageClick(_ sender: UIBarButtonItem) {
        self.webView.goBack()
    }
    @IBAction func nextPageClick(_ sender: UIBarButtonItem) {
        self.webView.goForward()
    }
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        dismissController()
    }
    
    var url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
        webView.delegate = self
        webView.loadRequest(URLRequest(url: URL(string: url)!))
        webView.scalesPageToFit = true
        activityIndicator.hidesWhenStopped = true
        previousButton.isEnabled = false
        nextButton.isEnabled = false
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(SearchViewController.dismissController))
        swipe.direction = .right
        self.view.addGestureRecognizer(swipe)
    }
    
    func dismissController() {
        let transition = CATransition()
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window?.layer.add(transition,forKey:nil)
        
        self.dismiss(animated: false, completion: nil)
    }
    
    //MARK: UIWebViewDelegate
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
        previousButton.isEnabled = webView.canGoBack ? true : false
        nextButton.isEnabled = webView.canGoForward ? true : false
    }
}
