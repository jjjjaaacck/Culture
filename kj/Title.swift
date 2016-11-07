import Foundation

class Title{
    let category=["cat_music", "cat_drama", "cat_dance", "cat_indie", "cat_movie", "cat_concert", "cat_exhibition", "cat_talk", "cat_entertainment", "cat_compet", "cat_kids", "cat_contest", "cat_course", "cat_other"]
    
    let categoryNumber = [1, 2, 3, 5, 8, 17, 6, 7, 11, 13, 4, 14, 19, 15]
    
    var categoryCount:Int{
        get{
            return category.count
        }
    }
}