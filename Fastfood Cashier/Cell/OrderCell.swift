//
//  OrderCell.swift
//  Fastfood Cashier
//
//  Created by Нуржан Керимбеков on 2021-11-04.
//

import UIKit

class OrderCell: UITableViewCell {

    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var orderNumberView: UIView!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var orderValueLabel: UILabel!
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var servedButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        orderNumberView.makeCircle()
        myView.layer.cornerRadius = 8
        servedButton.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func servedTapped(_ sender: Any) {
    }
}
