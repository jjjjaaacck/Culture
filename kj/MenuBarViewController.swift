//
//  ViewController.swift
//  leftBar
//
//  Created by BurdieTai on 2015/10/15.
//  Copyright © 2015年 BurdieTai. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit

class MenuBarViewController: UIViewController, FBSDKLoginButtonDelegate, UITableViewDataSource, UITableViewDelegate {
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
    }

    
    //fb
    @IBOutlet weak var profile_pic: FBSDKProfilePictureView!
    @IBOutlet var picView: UIView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var leftBarTableView: UITableView!
    
    let loginButton = FBSDKLoginButton()
    
    var option = [["title":"主頁","image":"menuHome.png"],
                  ["title":"日曆","image":"menuCalendar.png"],
                  ["title":"附近活動","image":"menuLocation.png"],
                  ["title":"書籤","image":"menuBookmark.png"],
                  ["title":"地區活動","image":"taiwan.png"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
        picView.layer.cornerRadius = picView.frame.width / 2
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        configureProfilePicture()
        
        //
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.delegate = self
        
        leftBarTableView.dataSource = self
        leftBarTableView.delegate = self
        leftBarTableView.isScrollEnabled = false
        
        self.view.addSubview(loginButton)
        
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(leftBarTableView.snp.bottom).offset(20)
            make.width.equalTo(90)
            make.height.equalTo(30)
            make.centerX.equalTo(leftBarTableView)
        }
        
        if ((FBSDKAccessToken.current()) != nil)
        {
            FBSDKProfile.enableUpdates(onAccessTokenChange: true)
            getFBUserData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getFBUserData(){
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
            if error == nil {
                self.userName.isHidden = false
                guard let resultNew = result as? [String:Any] else {
                    return
                }
                
                self.userName.text = resultNew["name"]  as? String
            }
        })
    }
    
    func configureProfilePicture(){
        profile_pic.layer.cornerRadius = profile_pic.frame.width/2
        profile_pic.layer.opacity = 0.8
        profile_pic.clipsToBounds = true
        profile_pic.layer.borderColor = (UIColor.lightGray.cgColor)
        self.view.addSubview(profile_pic)
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        if error != nil {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("public_profile")
            {
                getFBUserData()//print(result.token)
            }
        }
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!)
    {
        self.userName.text = ""
        self.userName.isHidden = true
        let alert = UIAlertController(title: "Logout", message:
            "Logout Successfully!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: false, completion: nil)
    }
    
    //MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return option.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionTableViewCell", for: indexPath) as! OptionTableViewCell
        
        cell.titleName.text = "\(self.option[(indexPath as NSIndexPath).row]["title"]!)"
        cell.titleName.sizeToFit()
        cell.titleImg.image = UIImage(named: self.option[(indexPath as NSIndexPath).row]["image"]!)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch indexPath.row {
        case 0:
            let navigationController = storyboard.instantiateViewController(withIdentifier: "MainNavigationController") as! UINavigationController
            self.revealViewController().setFront(navigationController, animated: true)
        case 1:
            let navigationController = storyboard.instantiateViewController(withIdentifier: "CalendarNavigationController") as! UINavigationController
            self.revealViewController().setFront(navigationController, animated: true)
        case 2:
            let navigationController = storyboard.instantiateViewController(withIdentifier: "MapNavigationController") as! UINavigationController
            self.revealViewController().setFront(navigationController, animated: true)
        case 3:
            let navigationController = storyboard.instantiateViewController(withIdentifier: "BookmarkNavigationController") as! UINavigationController
            self.revealViewController().setFront(navigationController, animated: true)
        case 4:
            let navigationController = storyboard.instantiateViewController(withIdentifier: "LocationNavigationController") as! UINavigationController
            self.revealViewController().setFront(navigationController, animated: true)
        default:
            break
        }
        self.revealViewController().setFrontViewPosition(.left, animated: true)
    }
}

