//
//  AccountViewController.swift
//  Fastfood Cashier
//
//  Created by Нуржан Керимбеков on 2021-11-07.
//

import UIKit
import RealmSwift

class AccountViewController: UIViewController,reloadTablesDelegate {
    func reloadAllTables() {
        categeryTableView.reloadData()
        itemTableView.reloadData()
        editItem = nil
        editCategory = nil
    }
    

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tablesStackView: UIStackView!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var addCategoryButton: UIButton!
    @IBOutlet weak var categeryTableView: UITableView!
    @IBOutlet weak var itemView: UIView!
    @IBOutlet weak var addItemButton: UIButton!
    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var branchLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var branchTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    let defaults = UserDefaults.standard
    var categoryList:Results<Category>?
    var itemList:List<Item>?
    var chosenCategory:Category?
    var editCategory:Category?
    var editItem:Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let realm = try Realm()
            categoryList = realm.objects(Category.self)
            if categoryList?.count ?? 0 > 0{
                chosenCategory = categoryList![0]
                itemList = chosenCategory!.itemlist
                categoryNameLabel.text = chosenCategory?.name
                categoryNameLabel.backgroundColor = UIColor(named: chosenCategory!.colorName) ?? .systemGray5
            }
        } catch {
            print("error gettinh category list and item list")
        }
        
        passwordTextField.delegate = self
        configureUI()
        configureFields()
        
        categeryTableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryTableViewCell")
        categeryTableView.delegate = self
        categeryTableView.dataSource = self
        
        itemTableView.register(UINib(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: "ItemTableViewCell")
        itemTableView.delegate = self
        itemTableView.dataSource = self
        
        let tapG = UITapGestureRecognizer(target: self, action: #selector(logoTaped))
        logoImageView.addGestureRecognizer(tapG)
        logoImageView.isUserInteractionEnabled = true
        
        logoImageView.image = downloadImageFromDirectory(name: "logo")
    }
    
    @objc func logoTaped(sender: UITapGestureRecognizer){
        if sender.state == .ended{
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            present(picker, animated: true, completion: nil)
        }
    }
    
    func configureUI(){
        editView.isHidden = true
        saveButton.isHidden = true
        logoImageView.makeCircle()
        
        mainView.layer.cornerRadius = 8
        categoryView.layer.cornerRadius = 8
        addCategoryButton.layer.cornerRadius = 8
        categeryTableView.layer.cornerRadius = 8
        addCategoryButton.layer.cornerRadius = 8
        itemView.layer.cornerRadius = 8
        itemTableView.layer.cornerRadius = 8
        addItemButton.layer.cornerRadius = 8
        headerView.layer.cornerRadius = 8
        
        //categoryNameLabel.layer.borderWidth = 0.5
        
        mainView.makeShadow()
        headerView.makeShadow()
        addItemButton.makeMiniShadow()
        addCategoryButton.makeMiniShadow()
        itemView.makeShadow()
        categoryView.makeShadow()
    }
    
    func configureFields() {
        logoImageView.image = UIImage(named: "logo")
        companyNameLabel.text = defaults.string(forKey: K.Defaults.companyName) ?? "Company Name"
        emailLabel.text = defaults.string(forKey: K.Defaults.email) ?? "Your Email"
        branchLabel.text = defaults.string(forKey: K.Defaults.branch) ?? "Your Branch"
        
        nameTextField.text = defaults.string(forKey: K.Defaults.companyName)
        branchTextField.text = defaults.string(forKey: K.Defaults.branch)
        passwordTextField.text = defaults.string(forKey: K.Defaults.password)
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "fromAccountToAddItem"{
            if chosenCategory != nil{
                return true
            }else{
                popError(alertTitle: "Be Careful", alertMessage: "Select a category", actionTitle: "Ok")
                return false
            }
        }else{
            return true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromAccountToAddItem"{
            let vc = segue.destination as! AddItemViewController
            vc.category = chosenCategory!
            vc.delegate = self
            if let item = editItem{
                vc.item = item
            }
        }else if segue.identifier == "fromAccountToAddCategory"{
            let vc = segue.destination as! AddCategoryViewController
            vc.delegate = self
            if let category = editCategory{
                vc.category = category
            }
        }
    }
    
    @IBAction func editTapped(_ sender: Any) {
        editView.isHidden = false
        saveButton.isHidden = false
        
        infoView.isHidden = true
        editButton.isHidden = true
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        infoView.isHidden = false
        editButton.isHidden = false
        
        editView.isHidden = true
        saveButton.isHidden = true
        
        defaults.setValue(nameTextField.text, forKey: K.Defaults.companyName)
        defaults.setValue(passwordTextField.text, forKey: K.Defaults.password)
        defaults.setValue(branchTextField.text, forKey: K.Defaults.branch)
        
        companyNameLabel.text = nameTextField.text == "" ? "Company Name":nameTextField.text
        branchLabel.text = branchTextField.text == "" ? "Branch":branchTextField.text
        
    }
}

extension AccountViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard textField.text != "" else {return}
        var oldTextField = UITextField()
        var newTextField = UITextField()
        let alert = UIAlertController(title: "Password", message: "Enter old password", preferredStyle: .alert)
        
        alert.addTextField { (uiTextField) in
            oldTextField = uiTextField
            uiTextField.placeholder = "Enter Old Password"
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.passwordTextField.text = self.defaults.string(forKey: K.Defaults.password)
        }
        
        let actionOk = UIAlertAction(title: "Check", style: .default) {[self] (alertAction) in
            if oldTextField.text == defaults.string(forKey: K.Defaults.password){
                let alert2 = UIAlertController(title: "Password", message: "Enter new password", preferredStyle: .alert)
                
                alert2.addTextField { (textField) in
                    newTextField = textField
                    textField.placeholder = "New Password"
                }
                
                let actionOk2 = UIAlertAction(title: "Ok", style: .default) { (action) in
                    self.passwordTextField.text = newTextField.text
                    self.defaults.setValue(newTextField.text, forKey: K.Defaults.password)
                }
                
                alert2.addAction(actionOk2)
                alert2.addAction(actionCancel)
                present(alert2, animated: false, completion: nil)
            }
            
            
        }
        
        alert.addAction(actionOk)
        alert.addAction(actionCancel)
        present(alert, animated: true, completion: nil)
    }
}

extension AccountViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1{
            return categoryList?.count ?? 0
        }else{
            return itemList?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
            
            cell.colorImageView.backgroundColor = UIColor(named: categoryList![indexPath.row].colorName) 
            cell.categoryNameLabel.text = categoryList![indexPath.row].name
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath) as! ItemTableViewCell
            let item = itemList![indexPath.row]
            cell.myImageView.image = downloadImageFromDirectory(name: "\(chosenCategory!.name)\(item.name)")
            cell.nameLabel.text = item.name
            cell.priceLabel.text = String(item.price)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 1{
            return 50
        }else{
            let item = itemList![indexPath.row]
            let text = item.name
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 1{
            chosenCategory = categoryList![indexPath.row]
            itemList = chosenCategory?.itemlist
            categoryNameLabel.text = chosenCategory?.name
            categoryNameLabel.backgroundColor = UIColor(named:(chosenCategory?.colorName)!) ?? .systemGray5
            itemTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if tableView.tag == 1{
                let category = categoryList![indexPath.row]
                do {
                    let realm = try Realm()
                    try realm.write{
                        realm.delete(category)
                    }
                    categeryTableView.reloadData()
                    chosenCategory = nil
                    itemList = nil
                    categoryNameLabel.text = "No Category Chosen"
                    categoryNameLabel.backgroundColor = .systemGray5
                    itemTableView.reloadData()
                } catch  {
                    print("")
                }
            }else if tableView.tag == 2{
                let item = itemList![indexPath.row]
                do {
                    let realm = try Realm()
                    try realm.write{
                        realm.delete(item)
                    }
                    itemTableView.reloadData()
                } catch  {
                    print("")
                }
            }
        }
    }
    
    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
            return self.makeContextMenu(for: indexPath, tag: tableView.tag)
        })
    }

    @available(iOS 13.0, *)
    func makeContextMenu(for indexPath: IndexPath, tag: Int) -> UIMenu {

        let editAction = UIAction(title: "Edit") { [weak self] _ in
            guard let self = self else { return }
            if tag == 1{
                self.editCategory = self.categoryList![indexPath.row]
                self.performSegue(withIdentifier: "fromAccountToAddCategory", sender: self)
            }else{
                self.editItem = self.itemList![indexPath.row]
                self.performSegue(withIdentifier: "fromAccountToAddItem", sender: self)
            }
        }
        return UIMenu(title: "Options", children: [editAction])
    }
    
   
}


extension AccountViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        saveImageInDirectory(image: image, name: "logo")
        logoImageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
