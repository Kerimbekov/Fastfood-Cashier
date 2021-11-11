//
//  Order.swift
//  Fastfood Cashier
//
//  Created by Нуржан Керимбеков on 2021-11-04.
//

import Foundation
import RealmSwift

class Order:Object {
    @objc dynamic var qty:Int = 0
    @objc dynamic var item:Item? = Item()
    @objc dynamic var sum:Double = 0.0
}
