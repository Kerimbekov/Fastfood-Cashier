//
//  OrderListItem.swift
//  Fastfood Cashier
//
//  Created by Нуржан Керимбеков on 2021-11-06.
//

import Foundation
import RealmSwift

class OrderListItem:Object {
    @objc dynamic var number:Int = 0
    @objc dynamic var name:String = ""
    @objc dynamic var sum:Double = 0.0
    @objc dynamic var served:Bool = false
    @objc dynamic var date:Date = Date()
    let orderList = List<Order>()
}
