//
//  CategoryCell.swift
//  Fastfood Cashier
//
//  Created by Нуржан Керимбеков on 2021-11-05.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    var category = Category()
    var list = [Item]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        myCollectionView.register(UINib(nibName: "ItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ItemCollectionViewCell")
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        myCollectionView.layer.cornerRadius = 12
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func getOrders() -> [Order]{
        var list = [Order]()
        for cell in myCollectionView.visibleCells{
            let myCell = cell as! ItemCollectionViewCell
            let qty = Int(myCell.qtyTextfield.text ?? "0")!
            if qty > 0{
                var order = Order()
                order.item = myCell.item
                order.qty = qty
                order.sum = Double(myCell.priceLabel.text ?? "0")!
                list.append(order)
            }
        }
        return list
    }
    
}

extension CategoryCell: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,minusDelegate{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell", for: indexPath) as! ItemCollectionViewCell
        let item = list[indexPath.item]
        cell.delegate = self
        cell.myImageView.image = item.image
        cell.nameLabel.text = item.name
        cell.priceLabel.text = ""
        cell.myView.backgroundColor = category.color
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ItemCollectionViewCell
        let qty = Int(cell.qtyTextfield.text!)! + 1
        cell.qtyTextfield.text = String(qty)
        cell.priceLabel.text = String(cell.item.price * Double(qty))
    }
    
    func minusTap(item:Item, cell:ItemCollectionViewCell) {
        var qty = Int(cell.qtyTextfield.text!)!
        if qty > 0{
            qty = qty - 1
            cell.qtyTextfield.text = String(qty)
            cell.priceLabel.text = qty == 0 ? "":String(Double(qty) * cell.item.price)
        }
    }
    
}
