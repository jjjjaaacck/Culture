import UIKit
import SwiftyJSON
import ChameleonFramework

class SessionTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var informations = [Information]()
    
    @IBOutlet weak var tableView: UITableView!
   
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: {})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
    
        let nib: UINib = UINib(nibName: "SessionTblViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "sessionCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    //MARK : UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return informations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "sessionCell", for: indexPath) as! SessionTableViewCell
        
        cell.locationLabel.text = informations[indexPath.row].location != "" ? informations[indexPath.row].location : "無提供地點"
        
        if let startTime = informations[indexPath.row].startTime {
            if let endTime = informations[indexPath.row].endTime {
                cell.timeLabel.text = dateToString(date: startTime) + " ~ " + dateToString(date: endTime)
            }
            else {
                cell.timeLabel.text = dateToString(date: startTime)
            }
        }
        else {
            if let endTime = informations[indexPath.row].endTime {
                cell.timeLabel.text = dateToString(date: endTime)
            }
            else {
                cell.timeLabel.text = "無提供時間"
            }
        }
        
        if informations[indexPath.row].latitude != 0.0 && informations[indexPath.row].longitude != 0.0 {
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let coordinate = [ Double(informations[indexPath.row].latitude), Double(informations[indexPath.row].longitude) ]
        if coordinate[0] != 0.0 && coordinate[1] != 0.0 {
            performSegue(withIdentifier: "showMap", sender: coordinate)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mapViewController: MapViewController = segue.destination as! MapViewController
        mapViewController.tempCoordinate = sender as! [Double]
    }
    
    func dateToString(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        return dateFormatter.string(from: date)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

