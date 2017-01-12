import UIKit

class OptionTableViewCell: UITableViewCell{

    @IBOutlet var titleView: UIView!
    @IBOutlet weak var titleImg: UIImageView!
    @IBOutlet weak var titleName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        titleView.layer.cornerRadius = titleView.frame.width / 2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
