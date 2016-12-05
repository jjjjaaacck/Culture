import UIKit
import GoogleMaps
import FBSDKShareKit

enum PresentControllerIdentifier: Int {
    case session = 0
    case infoWeb = 1
    case salesWeb = 2
    
    var identifier: String {
        switch self {
        case .session:
            return "SessionTableViewController"
        default:
            return "WebViewController"
        }
    }
}

class TransitionViewController: UIViewController, UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate, GMSMapViewDelegate, MainIntroViewDelegate {
    
    let optionInteractionController = InteractionController()
    
    var searchTitle: String!
    var index : Int = 0
    var nextY: CGFloat = 0
    var model = [Model]()
    var infos = [Info]()
    
    var contentView = UIView()
    var mainIntroView = MainIntroView()
    var activityIntroView = ActivityIntroView()
    //    var mapView = MapView()
    var map = GMSMapView()
    
    var mainDataId = ""
    var data = MainData()
    
    @IBOutlet var detailScrollView: DetailScrollView!
    
    @IBAction func closeButtonClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
            //            mapView = MapView(latitude: data.informations[0].latitude, longitude: data.informations[0].longitude)
            setMap(activityMap: map)
        }
        
        detailScrollView.addSubview(contentView)
        contentView.addSubview(mainIntroView)
        contentView.addSubview(activityIntroView)
        contentView.addSubview(map)
        //        contentView.addSubview(mapView)
        
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(detailScrollView).inset(UIEdgeInsetsMake(20, 20, 20, 20))
            make.width.equalTo(self.view.frame.width - 40)
            //            make.bottom.equalTo(mapView)
            make.bottom.equalTo(map)
        }
        
        mainIntroView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(0)
            make.top.equalTo(0)
        }
        
        activityIntroView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(0)
            make.top.equalTo(mainIntroView.snp.bottom).offset(20)
        }
        
        //        mapView.snp.makeConstraints { (make) in
        //            make.leading.trailing.equalTo(0)
        //            make.top.equalTo(activityIntroView.snp.bottom).offset(20)
        //            if isInformationHasLocation() {
        //                make.height.equalTo(160)
        //            }
        //            else {
        //                make.height.equalTo(0)
        //            }
        //        }
        
        map.snp.makeConstraints { (make) in
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
    
    func setMap(activityMap: GMSMapView) {
        let coordinate = CLLocationCoordinate2DMake(data.informations[0].latitude, data.informations[0].longitude)
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 15)
        activityMap.camera = camera
        activityMap.accessibilityElementsHidden = true
        activityMap.delegate = self
        activityMap.settings.scrollGestures = false
        activityMap.settings.zoomGestures = true
        activityMap.settings.compassButton = true
        activityMap.setMinZoom(8, maxZoom: 20)
        
        showMarker(mapview: activityMap, coordinate: coordinate)
    }
    
    func showMarker(mapview: GMSMapView, coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
        marker.icon = UIImage(named: "marker")
        marker.map = mapview
    }
    
    func presentController(identifier: PresentControllerIdentifier) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let transition = CATransition()
        
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        
        self.view.window?.layer.add(transition,forKey:nil)
        
        switch identifier {
        case .session:
            let controller = storyBoard.instantiateViewController(withIdentifier: identifier.identifier) as! SessionTableViewController
            controller.informations = self.data.informations.map{ $0 } as [Information]
            self.present(controller, animated: false, completion: nil)
        case .salesWeb:
            let controller = storyBoard.instantiateViewController(withIdentifier: identifier.identifier) as! WebViewController
            controller.url = self.data.salesUrl
            self.present(controller, animated: false, completion: nil)
            
        case .infoWeb:
            let controller = storyBoard.instantiateViewController(withIdentifier: identifier.identifier) as! WebViewController
            controller.url = self.data.webUrl
            self.present(controller, animated: false, completion: nil)
        }
    }
    
    //MARK: MainIntroViewDelegate
    
    func mainIntroViewSessionButtonClick() {
        presentController(identifier: PresentControllerIdentifier.session)
    }
    
    func mainIntroViewWebButtonClick() {
        presentController(identifier: PresentControllerIdentifier.infoWeb)
    }
    
    func mainIntroViewSalesButtonClick() {
        presentController(identifier: PresentControllerIdentifier.salesWeb)
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
            shareDetails.setObject(image!, forKey:"og:image" as NSCopying)
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
