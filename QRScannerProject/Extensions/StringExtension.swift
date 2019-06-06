//
//  StringExtension.swift
//  CashBaba
//
//  Created by Mamun Ar Rashid on 9/20/17.
//  Copyright © 2017 Recursion Technologies Ltd. All rights reserved.
//

import Foundation
import UIKit

extension String {
    /**
     true if self contains characters.
     */
    public var isNotEmpty: Bool {
        return !isEmpty
    }
}

extension String {
    static func isEmptyOrNull(_ string: String?) -> Bool {
        if let string = string {
            return string.trim().isEmpty ? true : false
        } else {
            return true
        }
    }
    static func formattedAmount(_ amount: NSNumber?) -> String {
        if let amount = amount {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale.current
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
            formatter.decimalSeparator = ","
            formatter.currencySymbol = "BDT "
            let formattedString = formatter.string(for: amount)
            return formattedString!
        } else {
            return "৳ 0.00"
        }
    }
    
    func toNSNumber() -> NSNumber?
    {
        if self.trim().isEmpty {
           return nil
        }
        if let double  = Double(self) {
          return NSNumber(value: double)
        }
        return nil
    }
    
    func trim() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}

extension String {
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[(start ..< end)])
    }
}


extension String {
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0)) else {
            return nil
        }
        
        return String(data: data as Data, encoding: String.Encoding.utf8)
    }
    
    func toBase64() -> String? {
        guard let data = self.data(using: String.Encoding.ascii) else {
            return nil
        }
        return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
}

extension String {
    
    func isValidEmail() -> Bool {
        print("validate emilId: \(self)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self)
        return result
    }
   
    func isValidName() -> Bool{
        let regex = try? NSRegularExpression(pattern: "^[\\p{L}\\.]{2,30}(?: [\\p{L}\\.]{2,30}){0,2}$", options: .caseInsensitive)
        
        return regex?.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil
    }
    
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
}



extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}
