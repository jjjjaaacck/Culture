import Foundation

class Category{
    var category = ["全部", "音樂", "表演", "學習", "競賽", "同樂", "其他"]
    
    func getCategory(_ index: Int)->String {
        return category[index]
    }
}
