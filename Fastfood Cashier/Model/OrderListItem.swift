//
//  OrderListItem.swift
//  Fastfood Cashier
//
//  Created by Нуржан Керимбеков on 2021-11-06.
//

import Foundation

public struct OrderListItem {
    var number = 1
    var name = ""
    var sum = 12.0
    var served = false
    var orderList = [Order]()
}
