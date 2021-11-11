//
//  ItemTableViewCell.swift
//  Fastfood Cashier
//
//  Created by Нуржан Керимбеков on 2021-11-08.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        myImageView.makeCircle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
