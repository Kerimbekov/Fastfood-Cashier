//
//  AddItemViewController.swift
//  Fastfood Cashier
//
//  Created by Нуржан Керимбеков on 2021-11-08.
//

import UIKit
import RealmSwift

class AddItemViewController: UIViewController {

    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
    var category = Category()
    var delegate:reloadTablesDelegate?
    var loadedImage = UIImage()
    var item:Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myView.layer.cornerRadius = 8
        addButton.layer.cornerRadius = 8
        logoImageView.makeCircle()
        addButton.makeShadow()
        
        let tapG = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        logoImageView.addGestureRecognizer(tapG)
        logoImageView.isUserInteractionEnabled = true
        
        if let item = item{
            logoImageView.image = downloadImageFromDirectory(name: "\(category.name)\(item.name)")
            loadedImage = logoImageView.image ?? UIImage(named: "pic")!
            nameTextField.text = item.name
            priceTextField.text = String(item.price)
        }
    }
    
    @objc func imageTapped(sender: UITapGestureRecognizer){
        if sender.state == .ended{
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .camera
            present(picker, animated: true, completion: nil)
        }
    }

    @IBAction func addTapped(_ sender: Any) {
        if let price = Double(priceTextField.text!), price != 0, let name = nameTextField.text, name != ""{
            let newItem = Item()
            newItem.name = name
            newItem.price = price
            newItem.image = logoImageView.image ?? UIImage(named: "pic")
            newItem.category = category
            
            do {
                let realm = try Realm()
                if let item = item{
                    try realm.write{
                        item.name = name
                        item.price = price
                    }
                    saveImageInDirectory(image: loadedImage, name: "\(category)\(item.name)")
                }else{
                    try realm.write{
                        category.itemlist.append(newItem)
                    }
                }
               
                
            } catch  {
                print("error updating category realm")
            }
            saveImageInDirectory(image: loadedImage, name: "\(category.name)\(name)")
            self.dismiss(animated: true) {
                self.delegate?.reloadAllTables()
            }
           
        }else{
            popError(alertTitle: "Be Careful", alertMessage: "Enter Name and Price for your Item", actionTitle: "Ok")
        }
    }
    
}

extension AddItemViewController:UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        loadedImage = image
        logoImageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
