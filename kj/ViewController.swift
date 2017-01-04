import UIKit
import SwiftyJSON
import ChameleonFramework
import SnapKit
import BoltsSwift
import RealmSwift

enum ScrollViewType: Int {
    case title = 1
    case content = 2
}

extension DataTableViews {
    func fetchData()  {
//        FetchData.sharedInstance.delegate = self
        let filter = NSPredicate(format: "category == \(self.category!)")
        RealmManager.sharedInstance.tryFetchMainDataByFilter(filter).continueWith { task in
            if task.faulted {
                FetchData.sharedInstance.RequestForData(self.category!, sendCurrentProgress: { progress in
                    self.setProgress(progress: progress)
                }).continueWith { task in
                    if task.faulted {
                        print("fetchData error : \(task.error), with category: \(self.category!)")
                        self.showErrorLabel()
                    }
                    else {
                        self.data = task.result as! [MainData]
                        RealmManager.sharedInstance.addDataTableViewData(task.result as! [MainData]).continueOnSuccessWith { task in
                            DispatchQueue.main.async {
                                self.reloadTableView()
                            }
                        }
                    }
                }
            }
            else {
                self.data = task.result as! [MainData]
                DispatchQueue.main.async(execute: {
                    self.reloadTableView()
                })
            }
        }
    }
    
    func requestProgress(progress: Double) {
        setProgress(progress: progress)
    }
}

class ViewController: UIViewController, UIScrollViewDelegate, UIViewControllerTransitioningDelegate, DataTableViewsDelegate, ToTopButtonDelegate {
    
    var header = Title()
    var categoryTitle = NSMutableArray()
    var refreshControl : UIRefreshControl!
    var pageControl: UIPageControl!
    var nowPage:Int = 0
    var dataTableViewArray = [DataTableViews]()
    
    @IBOutlet var titleScrollView: UIScrollView!
    @IBOutlet var contentScrollView: UIScrollView!
    @IBOutlet var menu: UIBarButtonItem!
    @IBOutlet var searchButton: UIBarButtonItem!
    @IBOutlet var subTitle: subtitle!
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        loadTitleScrollView()
        loadMenuSearch()
        loadPageTableView()
        loadToTopButton()
        
        self.view.backgroundColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    //MARK: Action
    
    func searchButtonClick() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        
       // self.view.window?.layer.add(transition,forKey:nil)
       // self.present(controller, animated: false, completion: nil)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func titleItemTap(_ sender:UITapGestureRecognizer){
        let titleImage = sender.view as! TitleItem
        nowPage = titleImage.tag
        setCurrentContent(nowPage)
        setCurrentTitle(nowPage)
        pageControl.currentPage = nowPage
    }
    
    //MARK: Method
    
    func loadTitleScrollView(){
        
        let titleScrollViewHeight = titleScrollView.constraints.first!.constant
        
        titleScrollView.tag = ScrollViewType.title.rawValue
        titleScrollView.contentSize = CGSize(width: titleScrollViewHeight*2.25*CGFloat(header.categoryCount), height: titleScrollViewHeight)
        titleScrollView.bounces = false
        titleScrollView.delegate = self
        
        for index in 0 ..< header.categoryCount {
            
            let titleItem = TitleItem(image: UIImage(named: header.category[index])!, index: index)
            
            if index == 0 {
                titleItem.layer.opacity = 0.6
            }
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.titleItemTap(_:)))
            tap.numberOfTapsRequired = 1
            titleItem.addGestureRecognizer(tap)
            
            categoryTitle.add(titleItem)
            titleScrollView.addSubview(titleItem)
            
            titleItem.snp.makeConstraints({ (make) -> Void in
                make.leading.equalTo(titleScrollViewHeight*2.25*CGFloat(index)+5)
                make.width.equalTo((titleScrollViewHeight-5)*2.25)
                make.height.equalTo((titleScrollViewHeight-5))
                make.top.equalTo(titleScrollView.snp.top)
            })
        }
    }
    
    func loadMenuSearch(){
        menu.target = self.revealViewController()
        menu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        searchButton.target = self
        searchButton.action = #selector(ViewController.searchButtonClick)
    }
    
    func loadPageTableView() {
        let width  = self.view.frame.size.width
        let pageSize = header.categoryCount
        
        contentScrollView.tag = ScrollViewType.content.rawValue
        contentScrollView.delegate = self
        contentScrollView.contentSize.width = CGFloat(pageSize) * width
        contentScrollView.isDirectionalLockEnabled = true
        contentScrollView.bounces = false
        self.view.addSubview(contentScrollView)
        
        for index in 0 ..< pageSize {
            
            let dataTableView = DataTableViews(category: header.categoryNumber[index])
            
            dataTableView.delegate = self
            
            contentScrollView.addSubview(dataTableView)
            
            dataTableView.snp.makeConstraints({ (make) -> Void in
                make.leading.equalTo(CGFloat(index) * width)
                make.width.equalTo(width)
                make.top.equalTo(contentScrollView)
                make.bottom.equalTo(self.view)
            })
            
            dataTableView.addRefreshControl()
            
            dataTableViewArray.append(dataTableView)
            dataTableView.fetchData()
        }
        
        pageControl = UIPageControl()
        pageControl.numberOfPages = pageSize
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
    }
    
    func loadToTopButton() {
        let toTopButton = ToTopButton()
        
        self.view.addSubview(toTopButton)
        
        toTopButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 50, height: 50))
            make.bottom.equalTo(self.view).offset(-10)
            make.trailing.equalTo(self.view).offset(-10)
        }
        
        toTopButton.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let detailController: TransitionViewController = segue.destination as! TransitionViewController
            detailController.mainDataId = sender as! String
        }
    }
    
    func setCurrentTitle(_ currentPage:Int){
        let titleImage = categoryTitle.object(at: currentPage) as! TitleItem
        let height = titleScrollView.frame.size.height
        let width = titleScrollView.frame.size.width
        var point = CGPoint(x: 0, y: 0)
        
        if height*2.25*CGFloat(currentPage)+width == titleScrollView.frame.width {
            point = CGPoint(x: 0, y: 0)
        }
        else if height*2.25*CGFloat(currentPage)+width > titleScrollView.contentSize.width {
            point = CGPoint(x: titleScrollView.contentSize.width-width, y: 0)
        }
        else {
            let a = height*2.25*CGFloat(currentPage)
            let b = (titleScrollView.frame.size.width-height*2.25)/2
            point = CGPoint(x: a - b, y: 0)
        }
        
        for item in categoryTitle {
            (item as AnyObject).layer.opacity = 1
        }
        
        titleImage.layer.opacity = 0.6
        titleScrollView.setContentOffset(point, animated: true)
    }
    
    func setCurrentContent(_ currentPage: Int) {
        contentScrollView.setContentOffset(CGPoint(x: CGFloat(nowPage) * contentScrollView.frame.width, y: 0), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: DataTableViewsDelegate
    
    func selectRow(_ mainDataId: String) {
        self.performSegue(withIdentifier: "showDetail", sender: mainDataId)
    }
    
    func bookmarkClick(currentBookMarkState: Bool, completion: @escaping (Bool) -> Void) {
        if currentBookMarkState {
            let alertController = UIAlertController(title: "移除書籤", message: "確定要移除書籤嗎", preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (result : UIAlertAction) -> Void in
                completion(false)
            }
            let okAction = UIAlertAction(title: "確定", style: .default) { (result : UIAlertAction) -> Void in
                completion(true)
            }
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            completion(true)
        }
    }
    
    //MARK: ToTopButtonDelegate
    
    func toTopButtonClick() {
        dataTableViewArray[nowPage].scrollToTop()
    }
    
    //MARK: UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        switch scrollView.tag {
        case ScrollViewType.title.rawValue:
            let width = scrollView.frame.height * 2.25
            nowPage = Int(ceil((scrollView.contentOffset.x - width / 2) / width))
            setCurrentContent(nowPage)
            setCurrentTitle(nowPage)
        case ScrollViewType.content.rawValue:
            if fmod(scrollView.contentOffset.x, scrollView.frame.maxX) == 0 {
                nowPage = Int(scrollView.contentOffset.x / scrollView.frame.maxX)
                pageControl.currentPage = nowPage
                setCurrentTitle(nowPage)
            }
        default:
            break
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.tag == ScrollViewType.title.rawValue && !decelerate {
            let width = scrollView.frame.height * 2.25
            nowPage = Int(ceil((scrollView.contentOffset.x - width / 2) / width))
            setCurrentContent(nowPage)
            setCurrentTitle(nowPage)
        }
    }
}
