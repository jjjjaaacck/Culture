import UIKit

class OptionTableViewCell: UITableViewCell{

    @IBOutlet var titleView: UIView!
    @IBOutlet weak var titleImg: UIImageView!
    @IBOutlet weak var titleName: UILabel!
    
/*
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //initViews()
    }

    @IBInspectable var img: UIImage?{
        get {
            return titleImage.image
        }
        set(img) {
            titleImage.image = img
        }
    }
    
    @IBInspectable var tle: String?{
        get {
            return title.text
        }
        set(tle) {
            title.text = tle
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       // initViews()
    }*/

    override func awakeFromNib() {
        super.awakeFromNib()
        titleView.layer.cornerRadius = titleView.frame.width / 2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
