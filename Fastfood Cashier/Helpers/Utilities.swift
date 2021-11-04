//
//  Utilities.swift
//  Fastfood Cashier
//
//  Created by Нуржан Керимбеков on 2021-11-04.
//

import Foundation

class Utitlies {
    
    static func isValidPassword(password: String) -> Bool {
        //Now we check if password contains one big letter, one number and and is minimum eight char long
        let passwordTest = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z]).{8,}$")
        return passwordTest.evaluate(with: password)
    }
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}
