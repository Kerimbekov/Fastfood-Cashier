//
//  AddCategoryViewController.swift
//  Fastfood Cashier
//
//  Created by Нуржан Керимбеков on 2021-11-08.
//

import UIKit
import RealmSwift

class AddCategoryViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var color1Button: UIButton!
    @IBOutlet weak var color2Button: UIButton!
    @IBOutlet weak var color3Button: UIButton!
    @IBOutlet weak var color4Button: UIButton!
    @IBOutlet weak var color5Button: UIButton!
    @IBOutlet weak var color6Button: UIButton!
    @IBOutlet weak var color7Button: UIButton!
    @IBOutlet weak var color8Button: UIButton!
    @IBOutlet weak var color9Button: UIButton!
    @IBOutlet weak var add: UIButton!
    
    var chosenColor = "color1"
    var delegate:reloadTablesDelegate?
    var category:Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        color1Button.layer.cornerRadius = 8
        color2Button.layer.cornerRadius = 8
        color3Button.layer.cornerRadius = 8
        color4Button.layer.cornerRadius = 8
        color5Button.layer.cornerRadius = 8
        color6Button.layer.cornerRadius = 8
        color7Button.layer.cornerRadius = 8
        color8Button.layer.cornerRadius = 8
        color9Button.layer.cornerRadius = 8
        mainView.layer.cornerRadius = 8
        add.layer.cornerRadius = 8
        add.makeShadow()
        
        
        if let category = category{
            nameTextField.text = category.name
            chosenColor = category.colorName
            let lastChar = category.colorName.last
            switch lastChar {
            case "1":
                color1Button.makeGreenBorder()
                chosenColor = "color1"
            case "2":
                color2Button.makeGreenBorder()
                chosenColor = "color2"
            case "3":
                color3Button.makeGreenBorder()
                chosenColor = "color3"
            case "4":
                color4Button.makeGreenBorder()
                chosenColor = "color4"
            case "5":
                color5Button.makeGreenBorder()
                chosenColor = "color5"
            case "6":
                color6Button.makeGreenBorder()
                chosenColor = "color6"
            case "7":
                color7Button.makeGreenBorder()
                chosenColor = "color7"
            case "8":
                color8Button.makeGreenBorder()
                chosenColor = "color8"
            case "9":
                color9Button.makeGreenBorder()
                chosenColor = "color9"
            default:
                color1Button.makeGreenBorder()
                chosenColor = "color1"
            }
        }else{
            color1Button.makeGreenBorder()
        }
    }

    @IBAction func color1Tapped(_ sender: Any) {
        removeBorders()
        color1Button.makeGreenBorder()
        chosenColor = "color1"
    }
    
    @IBAction func color2Tapped(_ sender: Any) {
        removeBorders()
        color2Button.makeGreenBorder()
        chosenColor = "color2"
    }
    
    @IBAction func color3Tapped(_ sender: Any) {
        removeBorders()
        color3Button.makeGreenBorder()
        chosenColor = "color3"
    }
    
    @IBAction func color4Tapped(_ sender: Any) {
        removeBorders()
        color4Button.makeGreenBorder()
        chosenColor = "color4"
    }
    
    @IBAction func color5Tapped(_ sender: Any) {
        removeBorders()
        color5Button.makeGreenBorder()
        chosenColor = "color5"
    }
    
    @IBAction func color6Tapped(_ sender: Any) {
        removeBorders()
        color6Button.makeGreenBorder()
        chosenColor = "color6"
    }
    @IBAction func color7Tapped(_ sender: Any) {
        removeBorders()
        color7Button.makeGreenBorder()
        chosenColor = "color7"
    }
    
    @IBAction func color8Tapped(_ sender: Any) {
        removeBorders()
        color8Button.makeGreenBorder()
        chosenColor = "color8"
    }
    
    @IBAction func color9Tapped(_ sender: Any) {
        removeBorders()
        color9Button.makeGreenBorder()
        chosenColor = "color9"
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        if let name = nameTextField.text, name != ""{
            do {
                let newCategory = Category()
                newCategory.name = name
                newCategory.colorName = chosenColor
                let realm = try Realm()
                if let category = category{
                    try realm.write{
                        category.colorName = chosenColor
                        category.name = name
                    }
                }else{
                    try realm.write{
                        realm.add(newCategory)
                    }
                }
                
                self.dismiss(animated: true) {
                    self.delegate?.reloadAllTables()
                }
            } catch{
                print("error adding category to realm\(error)")
            }
        }else{
            popError(alertTitle: "Name", alertMessage: "Empty Category Name", actionTitle: "Ok")
        }
    }
    
    func removeBorders(){
        color1Button.layer.borderWidth = 0
        color2Button.layer.borderWidth = 0
        color3Button.layer.borderWidth = 0
        color4Button.layer.borderWidth = 0
        color5Button.layer.borderWidth = 0
        color6Button.layer.borderWidth = 0
        color7Button.layer.borderWidth = 0
        color8Button.layer.borderWidth = 0
        color9Button.layer.borderWidth = 0
    }
    
}


protocol reloadTablesDelegate{
    func reloadAllTables()
}
