//
//  Category.swift
//  Fastfood Cashier
//
//  Created by Нуржан Керимбеков on 2021-11-05.
//

import Foundation
import UIKit

struct Category {
    var name = "Shaurma"
    var itemlist = [Item]()
    var color = UIColor()
}

class Test {
    var orderListItemList = [OrderListItem]()
    var categoryList = [Category]()
    
    static var shared:Test{
        let instance = Test()
        return instance
    }
    
    init() {
        var category = Category()
        category.color = UIColor(named: "color2")!
        var category2 = Category()
        category2.color = UIColor(named: "color1")!
        
        let item1 = Item()
        let item2 = Item(image: UIImage(named: "pic"), name: "waurma ostraia", price: 140)
        let item3 = Item(image: UIImage(named: "pic"), name: "waurma ostraia kurica", price: 150)
        
        category.itemlist.append(item1)
        category.itemlist.append(item2)
        category.itemlist.append(item3)
        
        category2.itemlist.append(item1)
        category2.itemlist.append(item2)
        category2.itemlist.append(item3)
        category2.itemlist.append(item1)
        category2.itemlist.append(item2)
        category2.itemlist.append(item3)
        
        categoryList.append(category)
        categoryList.append(category2)
    }
}
