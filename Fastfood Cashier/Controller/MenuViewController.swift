//
//  MenuViewController.swift
//  Fastfood Cashier
//
//  Created by Нуржан Керимбеков on 2021-11-05.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var saveView: UIView!
    @IBOutlet weak var saveImageView: UIImageView!
    
    let test = Test()
    var orderListItem = OrderListItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveView.makeCircle()
        let tapG = UITapGestureRecognizer(target: self, action: #selector(saveTapped))
        saveView.addGestureRecognizer(tapG)
        saveView.isUserInteractionEnabled = true
        
        myTableView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellReuseIdentifier: "CategoryCell")
        myTableView.delegate = self
        myTableView.dataSource = self
    }
    
    @objc func saveTapped(sender: UITapGestureRecognizer){
        if sender.state == .ended{
            var name = ""
            var sum = 0.0
            for cell in myTableView.visibleCells{
                let myCell = cell as! CategoryCell
                let orderList = myCell.getOrders()
                for order in orderList{
                    name.append("\(order.item.name)(\(order.qty)) ")
                    sum = sum + order.sum
                    orderListItem.orderList.append(order)
                }
            }
            orderListItem.name = name
            orderListItem.served = false
            orderListItem.sum = sum
            publicList.append(orderListItem)
            navigationController?.popViewController(animated: true)
        }
    }


}

extension MenuViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return test.categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        
        let category = test.categoryList[indexPath.row]
        cell.category = category
        cell.list = category.itemlist
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = (55 * test.categoryList[indexPath.row].itemlist.count)
        return CGFloat(height)
    }
    

}
