import UIKit
import SwiftyJSON
import ChameleonFramework

class SessionTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableview: UITableView!
    var infos = [Info]()
    
    @IBAction func backButtonClick(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: {})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
        let nib: UINib = UINib(nibName: "SessionTblViewCell", bundle: nil)
        tableview.register(nib, forCellReuseIdentifier: "sessionCell")
        tableview.dataSource = self
        tableview.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "sessionCell", for: indexPath) as! SessionTableViewCell
        
        if infos[(indexPath as NSIndexPath).row].location! != "" {
            cell.locationLabel.text = infos[(indexPath as NSIndexPath).row].location!
        }
        else {
            cell.locationLabel.text = "無提供地點"
        }
        
        if infos[(indexPath as NSIndexPath).row].startTime! == "" && infos[(indexPath as NSIndexPath).row].endTime! == "" {
            cell.timeLabel.text = "無提供時間"
        }
        else if infos[(indexPath as NSIndexPath).row].startTime! != "" && infos[(indexPath as NSIndexPath).row].endTime! == "" {
            cell.timeLabel.text = infos[(indexPath as NSIndexPath).row].startTime!
        }
        else if infos[(indexPath as NSIndexPath).row].startTime! == "" && infos[(indexPath as NSIndexPath).row].endTime! != "" {
            cell.timeLabel.text = infos[(indexPath as NSIndexPath).row].endTime!
        }
        else{
            cell.timeLabel.text = infos[(indexPath as NSIndexPath).row].startTime! + " ~ " + infos[(indexPath as NSIndexPath).row].endTime!
        }
        
        if infos[(indexPath as NSIndexPath).row].latitude! != 0.0 && infos[(indexPath as NSIndexPath).row].longitude! != 0.0 {
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator

        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coordinate = [ Double(infos[(indexPath as NSIndexPath).row].latitude!), Double(infos[(indexPath as NSIndexPath).row].longitude!) ]
        if coordinate[0] != 0.0 && coordinate[1] != 0.0 {
            performSegue(withIdentifier: "showMap", sender: coordinate)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mapViewController: MapViewController = segue.destination as! MapViewController
        mapViewController.tempCoordinate = sender as! [Double]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

