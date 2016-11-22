import UIKit

class WebViewController:  UIViewController, UIWebViewDelegate{
    
    @IBOutlet weak var previousButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var webView: UIWebView!
    @IBAction func previousPageClick(_ sender: UIBarButtonItem) {
        goBack()
    }
    @IBAction func nextPageClick(_ sender: UIBarButtonItem) {
        goForward()
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
//        
        let swipeToBack = UISwipeGestureRecognizer(target: self, action: #selector(WebViewController.goBack))
        let swipeToForward = UISwipeGestureRecognizer(target: self, action: #selector(WebViewController.goForward))
        swipeToBack.direction = .right
        swipeToForward.direction = .left
        self.view.addGestureRecognizer(swipeToBack)
        self.view.addGestureRecognizer(swipeToForward)
    }
    
    func goBack() {
        self.webView.goBack()
    }
    
    func goForward() {
        self.webView.goForward()
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
