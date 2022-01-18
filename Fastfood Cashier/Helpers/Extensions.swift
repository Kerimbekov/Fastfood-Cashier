//
//  Extensions.swift
//  Fastfood Cashier
//
//  Created by Нуржан Керимбеков on 2021-11-04.
//

import Foundation
import UIKit

extension UIView {
    func makeRounded() {
        self.layer.cornerRadius = self.frame.size.height / 6
    }
    
    func makeRoundedByEight(){
        self.layer.cornerRadius = 8
    }
    
    func makeCircle() {
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
    
    func makeBorder(){
        self.layer.borderWidth = 0.1
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    func makeBigBorder() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    func makeGreenBorder(){
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    func makeShadow(){
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 3
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func makeMiniShadow(){
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 1.5
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func popError(alertTitle: String, alertMessage: String, actionTitle: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let action = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    

    
    func saveImageInDirectory(image: UIImage, name:String) {
        guard let data = image.jpegData(compressionQuality: 0.05) else {return}
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "\(name)"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        do {
            try data.write(to: fileURL)
            print("file saved----\(fileName)")
        } catch {
            print("error saving file:", error)
        }
    }
    
    func downloadImageFromDirectory(name:String) -> UIImage{
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "\(name)"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        var image = UIImage(named: "pic")
        fileURL.loadImage(&image)
        return image!
    }
}

extension URL {
    func loadImage(_ image: inout UIImage?) {
        if let data = try? Data(contentsOf: self), let loaded = UIImage(data: data) {
            image = loaded
        } else {
            image = UIImage(named: "logo")
        }
    }
}

extension Date {
    func beginningOfDay() -> Date {
        let calendar = NSCalendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: self as Date)
        components.timeZone = TimeZone(abbreviation: "GMT")
        return calendar.date(from: components)!
    }
    
    
    func localDate() -> Date {
        let nowUTC = Date()
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return Date()}
        
        return localDate
    }
    
}
