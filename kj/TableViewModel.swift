import UIKit

class TableViewModel: UITableViewController {
    
//    var coreDataController = CoreDataController()
//   // var category = [1, 2, 3, 4, 5, 6, 7, 8, 11, 13, 14, 15, 17, 19]
//    var category = [1, 2, 3, 5, 8, 17, 6, 7, 11, 13, 4, 14, 19, 15]
//    var model = Array<Array<Model>>()
//    var infos = [Info]()
//    
//    func Load() {
//        if coreDataController.getModelByCategory(1, sort : "title").count == 0 {
//            coreDataController.jsonToCoreData()
//        }
//        
//        for i in 0 ..< 14 {
//            let m = coreDataController.getModelByCategory(category[i], sort : "startDate")
//            model.append(m)
//        }
//    }
//    
//    func LoadById(_ ids: [String]) {
//        model.removeAll()
//        var mm = [Model]()
//        for id in ids {
//            let m = coreDataController.getModelById(id)
//            mm.append(m[0])
//        }
//        
//        model.append(mm)
//    }
//    
//    func getCategory(_ index: Int) -> Int {
//        return category[index]
//    }
//    
//    func getModel()->TableViewModel{
//        return self
//    }
//
//    func dataHasImage(_ tableIndex : Int, indexPath: Int)->Bool{
//        return model[tableIndex][indexPath].imageUrl != "" ? true : false
//    }
//
//    func setActivityData(_ cell: TblViewCell, tableIndex : Int, index : Int) -> TblViewCell{
//        cell.activityName.text = model[tableIndex][index].title
//        cell.activityCategory = setCategoryImage(Int(model[tableIndex][index].category!), category: cell.activityCategory)
//        cell.activityCategoryView.layer.cornerRadius = cell.activityCategoryView.frame.size.width/2
//        cell.activityCategoryView.backgroundColor = cell.activityCategory.backgroundColor
//        
////        cell.activityBookmark.tableIndex = tableIndex
////        cell.activityBookmark.index = index
////        cell.activityBookmark = setBookMarkImage(model[tableIndex][index].bookMark!, bookMark: cell.activityBookmark)
//        
//        infos = coreDataController.getInfoById(model[tableIndex][index].id!)
//        if infos == [] {
//            cell.activityLocation.text = "無提供地點"
//        }
//        else if infos[0].location as String! == "" {
//            cell.activityLocation.text = "無提供地點"
//        }
//        else {
//            cell.activityLocation.text = infos[0].location as String!
//        }
//        
//        let startDate = model[tableIndex][index].startDate!
//        let endDate = model[tableIndex][index].endDate!
//        
//        if endDate != "" {
//            cell.activityTime.text = "\(startDate) ~ \(endDate)"
//        }
//        else {
//            cell.activityTime.text = "\(startDate)"
//        }
//        return cell
//    }
//    
//    func setActivityBookmark(_ cell: TblViewCell) -> TblViewCell{
//        cell.activityBookmark.addTarget(self, action: #selector(TableViewModel.bookmarkClick(_:)), for: UIControlEvents.touchUpInside)
//        return cell
//    }
//    
//    func bookmarkClick(_ sender : BookmarkButton) {
//        var image = UIImage()
//        if sender.tag == 1 {
//            image = UIImage(named: "bookmark2")!
//            sender.tag = 2
//        }
//        else {
//            image = UIImage(named: "bookmark1")!
//            sender.tag = 1
//        }
//        sender.setImage(image, for: UIControlState())
//        coreDataController.changeBookMark(model[sender.tableIndex][sender.index].id!)
//    }
//    
//    func setCategoryImage(_ categoryName:Int, category:UIImageView)->UIImageView{
//        
//        var image: UIImage = UIImage()
//        switch categoryName {
//        case 1:
//            image = UIImage(named: "music")!
//            category.backgroundColor = UIColor.flatRed()
//        case 2:
//            image = UIImage(named: "drama")!
//            category.backgroundColor = UIColor.flatLime()
//        case 3:
//            image = UIImage(named: "dance")!
//            category.backgroundColor = UIColor.flatYellow()
//        case 4:
//            image = UIImage(named: "family")!
//            category.backgroundColor = UIColor.flatMaroon()
//        case 5:
//            image = UIImage(named: "indieMusic")!
//            category.backgroundColor = UIColor.flatOrange()
//        case 6:
//            image = UIImage(named: "exibition")!
//            category.backgroundColor = UIColor.flatMagenta()
//        case 7:
//            image = UIImage(named: "lecture")!
//            category.backgroundColor = UIColor.flatMint()
//        case 8:
//            image = UIImage(named: "movie")!
//            category.backgroundColor = UIColor.flatGreen()
//        case 11:
//            image = UIImage(named: "entertainment")!
//            category.backgroundColor = UIColor.flatForestGreen()
//        case 13:
//            image = UIImage(named: "competition")!
//            category.backgroundColor = UIColor.flatBrown()
//        case 14:
//            image = UIImage(named: "competition")!
//            category.backgroundColor = UIColor.flatWatermelon()
//        case 15:
//            image = UIImage(named: "other")!
//            category.backgroundColor = UIColor.flatPowderBlue()
//        case 16:
//            image = UIImage(named: "music")!
//            category.backgroundColor = UIColor(red:0, green:0.75, blue:0.94, alpha:1)
//        case 17:
//            image = UIImage(named: "concert")!
//            category.backgroundColor = UIColor.flatPink()
//        case 19:
//            image = UIImage(named: "class")!
//            category.backgroundColor = UIColor.flatTeal()
//        default:
//            image = UIImage(named: "unknown")!
//            category.backgroundColor = UIColor.flatNavyBlue()
//        }
//        
//        category.image = image
//        return category
//    }
//    
//    func setBookMarkImage(_ state : NSNumber, bookMark : BookmarkButton) -> BookmarkButton {
//        var image : UIImage = UIImage()
//        
//        if(state == 0) {
//            image = UIImage(named: "bookmark1")!
//            bookMark.tag = 1
//        }
//        else {
//            image = UIImage(named: "bookmark2")!
//            bookMark.tag = 2
//        }
//        
//        bookMark.setImage(image, for: UIControlState())
//        return bookMark
//    }
//    
//    func getModelCount(_ tableIndex : Int) -> Int {
//        return model[tableIndex].count
//    }
//    
//    func getImageUrl(_ tableIndex : Int, index : Int) -> String{
//        return model[tableIndex][index].imageUrl!
//    }
//    
//    func AddDataByCategory(_ cat: Int) {
//        let index = self.category.index(of: cat) as Int?
//        self.model.remove(at: index!)
//        model.insert(coreDataController.getModelByCategory(cat, sort: "startDate"), at: index!)
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
}
