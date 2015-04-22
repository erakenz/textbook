//
//  CategoryItem.swift
//  textbook
//
//  Created by John Wong on 4/22/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import UIKit

class CollectItem: NSObject, NSCoding {
    let title: String
    let link: String
    let img: String
    
    let i = 3
    let f = 3.0
    
    init(title: String, link: String, img: String) {
        self.title = title
        self.link = link
        self.img = img
        super.init()
    }
    
    convenience override init() {
        self.init(title: "", link: "", img: "")
    }
    
    convenience init(dict: NSDictionary) {
        let title: String = dict["title"] is String ? dict["title"] as! String : ""
        let link: String = dict["link"] is String ? dict["link"] as! String : ""
        let img: String = dict["img"] is String ? dict["img"] as! String : ""
        self.init(title: title, link: link, img: img)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        let x = reflect(self)
        for i in 0 ..< x.count {
            let item = x[i]
            let key = item.0
            let value = item.1.value
            switch value {
            case let someBool as Bool:
                aCoder.encodeBool(someBool, forKey: key)
            case let someInt as Int:
                aCoder.encodeInteger(someInt, forKey: key)
            case let someFloat as Float:
                aCoder.encodeFloat(someFloat, forKey: key)
            case let someDouble as Double:
                aCoder.encodeDouble(someDouble, forKey: key)
            case let someString as String:
                aCoder.encodeObject(someString, forKey: key)
            default:
                println("something else \(key)")
            }
        }
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        let x = reflect(self)
        for i in 0 ..< x.count {
            let item = x[i]
            let key = item.0
            let value = item.1.value
            var newValue: AnyObject?
            switch value {
            case let someBool as Bool:
                newValue = aDecoder.decodeBoolForKey(key)
                
            case let someInt as Int:
                newValue = aDecoder.decodeIntegerForKey(key)
            case let someFloat as Float:
                newValue = aDecoder.decodeFloatForKey(key)
            case let someDouble as Double:
                newValue = aDecoder.decodeDoubleForKey(key)
            case let someString as String:
                let newObj = aDecoder.decodeObjectForKey(key) as! String
                self.setValue(newObj, forKeyPath: key)
                continue
            default:
                println("something else \(key)")
            }
            self.setValue(newValue, forKey: key)
        }
    }
}

class SubjectItem {
    let header: String
    let rows: Array<CollectItem>
    
    init(header: String, rows: Array<CollectItem>) {
        self.header = header
        self.rows = rows
    }
    
    convenience init() {
        self.init(header: "", rows: Array<CollectItem>())
    }
    
    convenience init(dict: NSDictionary) {
        let header: String = dict["header"] is String ? dict["header"] as! String : ""
        let collectArray: NSArray? = dict["rows"] as? NSArray
        var collectItems = Array<CollectItem>()
        if let collectArray = collectArray {
            for collect in collectArray {
                if let collect = collect as? NSDictionary {
                    collectItems.append(CollectItem(dict: collect))
                }
            }
        }
        self.init(header: header, rows: collectItems)
    }
}

class CategoryItem {
    let name: String
    let items: Array<SubjectItem>
    
    init(name: String, items: Array<SubjectItem>) {
        self.name = name
        self.items = items
    }
    
    convenience init() {
        self.init(name: "", items: Array<SubjectItem>())
    }
    
    convenience init(dict: NSDictionary) {
        let name: String = dict["name"] is String ? dict["name"] as! String : ""
        let subjectArray: NSArray? = dict["items"] as? NSArray
        var subjectItems = Array<SubjectItem>()
        if let subjectArray = subjectArray {
            for subject in subjectArray {
                if let subject = subject as? NSDictionary {
                    subjectItems.append(SubjectItem(dict: subject))
                }
            }
        }
        self.init(name: name, items: subjectItems)
    }
    
    class func arrayWithDict(dict: NSDictionary) -> Array<CategoryItem> {
        let categoryArray: NSArray? = dict["cates"] as? NSArray
        var categoryItems = Array<CategoryItem>()
        if let categoryArray = categoryArray {
            for category in categoryArray {
                if let category = category as? NSDictionary {
                    categoryItems.append(CategoryItem(dict: category))
                }
            }
        }
        return categoryItems
    }
}