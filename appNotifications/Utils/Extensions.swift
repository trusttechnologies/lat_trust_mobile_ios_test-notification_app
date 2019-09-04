//
//  Extensions.swift
//  appNotifications
//
//  Created by Jesenia Salazar on 9/2/19.
//  Copyright © 2019 Cristian Parra. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents

// MARK: Load image from URL
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}


// MARK: Verify if a URL is reachable
func verifyUrl (urlString: String?) -> Bool {
    //Check for nil
    if let urlString = urlString {
        // create NSURL instance
        if let url = NSURL(string: urlString) {
            // check if your application can open the NSURL instance
            return UIApplication.shared.canOpenURL(url as URL)
        }
    }
    return false
}

func parseNotification(content: [AnyHashable: Any]) -> GenericNotification {
    
    //take the notification content and convert it to data
    let jsonData = try! JSONSerialization.data(withJSONObject: content["data"], options: .prettyPrinted)
    
    //decode the notification with the structure of a generic notification
    let jsonDecoder = JSONDecoder()
    let notDialog = try! jsonDecoder.decode(GenericNotification.self, from: jsonData)

    return notDialog
}

extension UIColor {
    // MARK: - Values from Zeplin
    @nonobjc class var whiteRipple: UIColor {
        return UIColor(white: 1.0, alpha: 0.12)
    }
    @nonobjc class var white: UIColor {
        return UIColor(white: 1.0, alpha: 1.0)
    }
    @nonobjc class var black: UIColor {
        return UIColor(white: 33.0 / 255.0, alpha: 1.0)
    }
    
    
    // MARK: - Initialization
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt32 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt32(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    // MARK: - Computed Properties
    var toHex: String? {
        return toHex()
    }
    
    // MARK: - From UIColor to String
    func toHex(alpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        guard alpha else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
        
        return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
    }
}


enum CustomButtonType {
    case whiteButton
    case coloredButton
}

enum MdcType {
    case text
    case outlined
    case contained
}

extension MDCButton {
    
    func setupButtonWithType(color: String!, type: CustomButtonType, mdcType: MdcType) {
        
        let colorSchema = MDCSemanticColorScheme()
        let buttonScheme = MDCButtonScheme()
        
        switch type {
        case .whiteButton:
            colorSchema.primaryColor = UIColor.init(hex: color)!
            //colorSchema.onPrimaryColor = UIColor.init(hex: color)!
            self.inkColor = UIColor.init(hex: color)!.withAlphaComponent(0.12)
        case .coloredButton:
            colorSchema.primaryColor = UIColor.init(hex: color)!
            colorSchema.onPrimaryColor = .white
            self.inkColor = .whiteRipple
        }
        
        buttonScheme.colorScheme = colorSchema
        buttonScheme.cornerRadius = 8
        
        self.clipsToBounds = true
        
        switch mdcType {
        case .text:
            MDCTextButtonThemer.applyScheme(buttonScheme, to: self)
            
        case .outlined:
            MDCOutlinedButtonThemer.applyScheme(buttonScheme, to: self)
            
        case .contained:
            MDCContainedButtonThemer.applyScheme(buttonScheme, to: self)
        }
        self.isUppercaseTitle = true
    }
}
