import UIKit
import GoogleMaps
import FBSDKShareKit

class TransitionViewController: UIViewController, UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate, GMSMapViewDelegate, MainIntroViewDelegate {
    
    let optionInteractionController = InteractionController()
    //let optionPresentationController = OptionPresentationController()
    var detailCellRow:Int = 0
    var category : Int = 0
    var id: String = ""
    
    var searchTitle: String!
    var index : Int = 0
    var nextY: CGFloat = 0
    var model = [Model]()
    var infos = [Info]()
    
    var contentView = UIView()
    var mainIntroView = MainIntroView()
    var activityIntroView = ActivityIntroView()
    var mapView = MapView()
    
    var mainDataId = ""
    var data = MainData()
    
    @IBOutlet var detailScrollView: DetailScrollView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.commonInit()
    }
    
    func commonInit() {
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        optionInteractionController.attachToViewController(self)
        fetchData()
        setDetailScrollView()
    }
    
    func fetchData() {
        let filter = NSPredicate(format: "id = %@", mainDataId)
        RealmManager.sharedInstance.tryFetchMainDataByFilter(filter).continueWith { (task) -> AnyObject? in
            let data = task.result as! NSArray
            self.data = data[0] as! MainData
            return nil
        }
    }
    
    func setDetailScrollView() {
        mainIntroView = MainIntroView(width: self.view.frame.width - 40, data: data)
        activityIntroView = ActivityIntroView(width: self.view.frame.width - 40, data: data.detail)
        
        if isDataHasInformation() && isInformationHasLocation(){
            mapView = MapView(latitude: data.informations[0].latitude, longitude: data.informations[0].longitude)
        }
        
        detailScrollView.addSubview(contentView)
        contentView.addSubview(mainIntroView)
        contentView.addSubview(activityIntroView)
        contentView.addSubview(mapView)
        
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(detailScrollView).inset(UIEdgeInsetsMake(20, 20, 20, 20))
            make.width.equalTo(self.view.frame.width - 40)
            make.bottom.equalTo(mapView)
        }
        
        mainIntroView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(0)
            make.top.equalTo(0)
        }
        
        activityIntroView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(0)
            make.top.equalTo(mainIntroView.snp.bottom).offset(20)
        }
        
        mapView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(0)
            make.top.equalTo(activityIntroView.snp.bottom).offset(20)
            if isInformationHasLocation() {
                make.height.equalTo(160)
            }
            else {
                make.height.equalTo(0)
            }
        }
        
        mainIntroView.delegate = self
        
    }
    
    func isDataHasInformation() -> Bool {
        return data.informations.isEmpty ? false : true
    }
    
    func isInformationHasLocation() -> Bool {
        return data.informations[0].latitude == 0.0 && data.informations[0].longitude == 0.0 ? false : true
    }
    
//    func shareButtonClick(sender: UIButton){
//        let shareDetails : NSMutableDictionary
//        let title1 = model[index].title!
//        let title = data.title
//        let des = model[index].detail!
//        let description = data.detail
//        shareDetails = ["og:type":"culture_life:event","og:title":title,"og:description":des,"og:locale":"zh_TW"]
//        if data.webUrl != ""{
//            let url = data.webUrl
//            shareDetails.setObject(url, forKey:"og:url")
//        }
//        else
//        {
//            if data.salesUrl != ""{
//                let url = data.salesUrl
//                shareDetails.setObject(url, forKey:"og:url")
//            }
//        }
//        if data.imageUrl != ""{
//            let imageUrl = NSURL(string: data.imageUrl)
//            let image = FBSDKSharePhoto(imageURL: imageUrl, userGenerated: false)
//            shareDetails.setObject(image, forKey:"og:image")
//        }
//        let object = FBSDKShareOpenGraphObject(properties: shareDetails as [NSObject : AnyObject])
//        let action = FBSDKShareOpenGraphAction.init()
//        action.actionType = "culture_life:review"
//        action.setObject(object, forKey: "culture_life:event")
//        let content = FBSDKShareOpenGraphContent.init()
//        content.action = action
//        content.previewPropertyName = "culture_life:event"
//        FBSDKShareDialog.showFromViewController(self, withContent: content, delegate: nil)
//    }
    
//    func setMap() {
//        let coordinate = CLLocationCoordinate2DMake(Double(infos[0].latitude!), Double(infos[0].longitude!))
//        
//        if coordinate.longitude != 0.0 && coordinate.latitude != 0.0 {
//            let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(coordinate.latitude, longitude: coordinate.longitude, zoom: 15)
//            activityMap = GMSMapView.mapWithFrame(CGRectMake(10, nextY+10+15, view.frame.size.width-20, 160), camera: camera)
//            //activityMap = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
//            activityMap.accessibilityElementsHidden = true
//            activityMap.delegate = self
//            activityMap.settings.scrollGestures = false
//            activityMap.settings.zoomGestures = true
//            activityMap.settings.compassButton = true
//            //mapView.myLocationEnabled = true
//            //mapView.settings.myLocationButton = true
//            activityMap.setMinZoom(8, maxZoom: 20)
//            detailScrollView.addSubview(activityMap)
//            
//            nextY = activityMap.frame.maxY
//            
//            showMarker(activityMap, coordinate: coordinate)
//        }
//    }
    
//    func showMarker(mapview: GMSMapView, coordinate: CLLocationCoordinate2D) {
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
//        //marker.title = "Hello"
//        //marker.snippet = "I'm fine"
//        //marker.appearAnimation = kGMSMarkerAnimationPop
////        marker.icon = resizeImage(UIImage(named: "map-marker.png")!,size:CGSizeMake(30.0, 30.0))
//        marker.icon = UIImage(named: "marker")
//        marker.map = mapview
//    }
    
//    func openWeb(sender: UITapGestureRecognizer){
//        let label: UILabel = sender.view as! UILabel
//        let path = label.text
//        self.performSegueWithIdentifier("showWeb", sender: path!)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWeb" {
            let webViewController: WebViewController = segue.destination as! WebViewController
            webViewController.url = sender as! String
        }
        else if segue.identifier == "showSession" {
            let sessionTblViewController: SessionTableViewController = segue.destination as! SessionTableViewController
            sessionTblViewController.infos = sender as! [Info]
        }
    }
    
    //MARK: MainIntroViewDelegate
    
    func mainIntroViewWebButtonClick() {
        self.performSegue(withIdentifier: "showWeb", sender: self.data.webUrl)
    }
    
    func mainIntroViewSalesButtonClick() {
        self.performSegue(withIdentifier: "showWeb", sender: self.data.salesUrl)
    }
    
    func mainIntroViewShareButtonClick() {
        let shareDetails : NSMutableDictionary
        let title = data.title
        let description = data.detail
        shareDetails = ["og:type":"culture_life:event","og:title":title,"og:description":description,"og:locale":"zh_TW"]
        if data.webUrl != ""{
            let url = data.webUrl
            shareDetails.setObject(url, forKey:"og:url" as NSCopying)
        }
        else
        {
            if data.salesUrl != ""{
                let url = data.salesUrl
                shareDetails.setObject(url, forKey:"og:url" as NSCopying)
            }
        }
        if data.imageUrl != ""{
            let imageUrl = URL(string: data.imageUrl)
            let image = FBSDKSharePhoto(imageURL: imageUrl, userGenerated: false)
            shareDetails.setObject(image, forKey:"og:image" as NSCopying)
        }
//        let object = FBSDKShareOpenGraphObject(properties: shareDetails)
        let object = FBSDKShareOpenGraphObject(properties: shareDetails as NSDictionary as! [AnyHashable: Any])
        let action = FBSDKShareOpenGraphAction.init()
        action.actionType = "culture_life:review"
        action.setObject(object, forKey: "culture_life:event")
        let content = FBSDKShareOpenGraphContent.init()
        content.action = action
        content.previewPropertyName = "culture_life:event"
        FBSDKShareDialog.show(from: self, with: content, delegate: nil)
    }
    
    //MARK: UIViewControllerTransitioningDelegate
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        if presented == self {
            return OptionPresentationController(presentedViewController: presented, presenting: presenting)
        }
        
        return nil
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if presented == self {
            return OptionAnimator(isPresenting: true)
        }
        else {
            return nil
        }
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if dismissed == self {
            return OptionAnimator(isPresenting: false)
        }
        else {
            return nil
        }
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return optionInteractionController.transitionInProgress ? optionInteractionController : nil
    }

}
