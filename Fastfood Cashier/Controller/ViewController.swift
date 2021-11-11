//
//  ViewController.swift
//  Fastfood Cashier
//
//  Created by Нуржан Керимбеков on 2021-11-04.
//

import UIKit
import RealmSwift
import GoogleMobileAds


class ViewController: UIViewController {

    @IBOutlet weak var MybannerView: UIView!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var addImageView: UIImageView!
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var firmNameLabel: UILabel!
    
    var bannerView: GADBannerView!
    
    var list:Results<OrderListItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerView = GADBannerView(adSize: kGADAdSizeLeaderboard)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-9352557169154677/8396716453"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        do {
            let realm = try Realm()
            list = realm.objects(OrderListItem.self).filter("served = %@", false)
        } catch {
            print("error getting orderListItem from Realm")
        }
        
        addView.makeCircle()
        logoView.makeCircle()
        
        
        let tapG = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
        addView.addGestureRecognizer(tapG)
        addView.isUserInteractionEnabled = true
        
        myTableView.register(UINib(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier: "OrderCell")
        myTableView.delegate = self
        myTableView.dataSource = self
        
        logoView.image = downloadImageFromDirectory(name: "logo")
        firmNameLabel.text = UserDefaults.standard.string(forKey: K.Defaults.companyName)
        
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
          [NSLayoutConstraint(item: bannerView,
                              attribute: .bottom,
                              relatedBy: .equal,
                              toItem: bottomLayoutGuide,
                              attribute: .top,
                              multiplier: 1,
                              constant: 0),
           NSLayoutConstraint(item: bannerView,
                              attribute: .centerX,
                              relatedBy: .equal,
                              toItem: view,
                              attribute: .centerX,
                              multiplier: 1,
                              constant: 0)
          ])
       }
    
    override func viewWillAppear(_ animated: Bool) {
        myTableView.reloadData()
        logoView.image = downloadImageFromDirectory(name: "logo")
        firmNameLabel.text = UserDefaults.standard.string(forKey: K.Defaults.companyName)
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
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        let order = list[indexPath.row]
        cell.delegate = self
        cell.orderListItem = order
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
        
        let constraintRect = CGSize(width: suma.frame.width + 150,
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let item = list[indexPath.row]
            do {
                let realm = try Realm()
                try realm.write{
                    realm.delete(item)
                }
                
                myTableView.reloadData()
            } catch {
                print("error deleting from realm")
            }
        }
    }
    
}

extension ViewController:MainTableReloadDelegate{
    func reloadMyTabe() {
        myTableView.reloadData()
    }
}

