//
//  Item.swift
//  Fastfood Cashier
//
//  Created by Нуржан Керимбеков on 2021-11-05.
//

import Foundation
import UIKit
import RealmSwift

class Item: Object{
    @objc dynamic var imageName:String = "pic"
    var image = UIImage(named: "pic")
    @objc dynamic var name:String = ""
    @objc dynamic var price:Double = 0.0
    @objc dynamic var category:Category? = Category()
}
