//
//  Category.swift
//  Fastfood Cashier
//
//  Created by Нуржан Керимбеков on 2021-11-05.
//

import Foundation
import UIKit
import RealmSwift

class Category:Object {
    @objc dynamic var name:String = ""
    let itemlist = List<Item>()
    @objc dynamic var colorName:String = "color1"
}

