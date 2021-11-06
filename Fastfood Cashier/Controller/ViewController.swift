//
//  ViewController.swift
//  Fastfood Cashier
//
//  Created by Нуржан Керимбеков on 2021-11-04.
//

import UIKit

public var publicList = [OrderListItem]()

class ViewController: UIViewController {

    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var addImageView: UIImageView!
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var firmNameLabel: UILabel!
    
    var list = [OrderListItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addView.makeCircle()
        logoView.makeCircle()
        list = publicList
        
        let tapG = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
        addView.addGestureRecognizer(tapG)
        addView.isUserInteractionEnabled = true
        
        myTableView.register(UINib(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier: "OrderCell")
        myTableView.delegate = self
        myTableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        list = publicList
        myTableView.reloadData()
    }
    
    @objc func imageTapped(sender: UITapGestureRecognizer){
        if sender.state == .ended{
            let sboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = sboard.instantiateViewController(identifier: "MenuViewController")
            navigationController?.pushViewController(vc, animated: true)
        }
    }


}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("-----\(list.count)")
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        let order = list[indexPath.row]
        cell.orderNumberLabel.text = String(order.number)
        cell.orderValueLabel.text = order.name
        cell.sumLabel.text = "\(order.sum)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let order = list[indexPath.row]
        let text = order.name
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

