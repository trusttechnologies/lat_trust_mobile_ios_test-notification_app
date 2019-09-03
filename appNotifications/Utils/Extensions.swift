//
//  Extensions.swift
//  appNotifications
//
//  Created by Jesenia Salazar on 9/2/19.
//  Copyright © 2019 Cristian Parra. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

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

    
    print(JSONSerialization.isValidJSONObject(content["data"]))
    let jsonData = try! JSONSerialization.data(withJSONObject: content["data"], options: .prettyPrinted)
    let jsonDecoder = JSONDecoder()

    let notDialog = try! jsonDecoder.decode(GenericNotification.self, from: jsonData)

    return notDialog
}
