//
//  OrderCell.swift
//  Fastfood Cashier
//
//  Created by Нуржан Керимбеков on 2021-11-04.
//

import UIKit
import RealmSwift

class OrderCell: UITableViewCell {

    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var orderNumberView: UIView!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var orderValueLabel: UILabel!
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var servedButton: UIButton!
    
    var delegate:MainTableReloadDelegate?
    var orderListItem:OrderListItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        orderNumberView.makeCircle()
        myView.layer.cornerRadius = 8
        myView.makeMiniShadow()
        servedButton.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func servedTapped(_ sender: Any) {
        do {
            let realm = try Realm()
            try realm.write{
                orderListItem?.served = true
            }
            delegate?.reloadMyTabe()
        } catch  {
            print("error check served realm")
        }
    }
}

protocol MainTableReloadDelegate {
    func reloadMyTabe()
}
