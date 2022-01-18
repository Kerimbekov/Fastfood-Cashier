//
//  MenuViewController.swift
//  Fastfood Cashier
//
//  Created by Нуржан Керимбеков on 2021-11-05.
//

import UIKit
import RealmSwift

class MenuViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var saveView: UIView!
    @IBOutlet weak var saveImageView: UIImageView!
    
    var categoryList:Results<Category>?
    var orderListItem = OrderListItem()
    
    override func viewDidLoad(){
        
        do {
            let realm = try Realm()
            categoryList = realm.objects(Category.self)
        } catch  {
            print("error getting categories")
        }
        
        super.viewDidLoad()
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
                    name.append("\(order.item!.name)(\(order.qty)) ")
                    sum = sum + order.sum
                    orderListItem.orderList.append(order)
                }
            }
            if sum>0{
                var num = UserDefaults.standard.integer(forKey: K.Defaults.enumarator)
                num = num + 1
                UserDefaults.standard.set(num, forKey: K.Defaults.enumarator)
                orderListItem.number = num
                orderListItem.name = name
                orderListItem.served = false
                orderListItem.sum = sum
                orderListItem.date = Date().localDate()
                do {
                    let realm = try Realm()
                    try realm.write{
                        realm.add(orderListItem)
                    }
                } catch {
                    print("error adding orderList item Realm")
                }
            }
            navigationController?.popViewController(animated: true)
        }
    }


}

extension MenuViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        
        let category = categoryList![indexPath.row]
        cell.category = category
        cell.list = category.itemlist
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = (55 * categoryList![indexPath.row].itemlist.count)
        return CGFloat(height)
    }
    

}
