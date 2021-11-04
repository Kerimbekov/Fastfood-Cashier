//
//  ViewController.swift
//  Fastfood Cashier
//
//  Created by Нуржан Керимбеков on 2021-11-04.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var addImageView: UIImageView!
    
    var list = [Order]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addView.makeCircle()
        
        myTableView.register(UINib(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier: "OrderCell")
        myTableView.delegate = self
        myTableView.dataSource = self
        list.append(Order())
        var order = Order()
        order.value = "Nurzhab"
        list.append(order)
    }


}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        let order = list[indexPath.row]
        cell.orderNumberLabel.text = "\(order.number)"
        cell.orderValueLabel.text = order.value
        cell.sumLabel.text = "\(order.sum)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let order = list[indexPath.row]
        let text = order.value
        let label =  UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        label.text = text
        let suma = UITableViewCell()
        
        let constraintRect = CGSize(width: suma.frame.width,
                                    height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: label.font],
                                            context: nil)
        label.frame.size = CGSize(width: ceil(boundingBox.width),
                                  height: ceil(boundingBox.height))
        
        let bubbleImageSize = CGSize(width: label.frame.width,
                                     height: label.frame.height)
        
        let height = bubbleImageSize.height < 45 ? 45 : bubbleImageSize.height
        return height
    }
    
}

