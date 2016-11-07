//
//  Bookmark.swift
//  kj
//
//  Created by 劉 on 2015/10/8.
//  Copyright © 2015年 劉. All rights reserved.
//

import UIKit

class BookmarkButton: UIButton {
    
    var tableIndex : Int
    var index : Int
    
    fileprivate var _id = ""
    var id: String? {
        get{
            return _id
        }
        set(id){
            self._id = id!
        }
    }
    
    fileprivate var _isBookmark = false
    var isBookmark: Bool {
        get {
            return _isBookmark
        }
        set(isBookmark) {
            self._isBookmark = isBookmark
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        tableIndex = 0
        index = 0
        super.init(coder: aDecoder)
    }
    
    func setBookmarkId(_ id: String) {
        self.id = id
    }
    
    func getBookmarkId() -> String {
        return self.id!
    }

}
