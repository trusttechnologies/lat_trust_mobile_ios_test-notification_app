//
//  NotificationService.swift
//  ServiceNotificationExtension
//
//  Created by Cristian Parra on 28-08-19.
//  Copyright © 2019 Cristian Parra. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    var download = FileDownloader()

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            if let data = bestAttemptContent.userInfo["data"] as? Dictionary<AnyHashable, Any>{
                if let body = data["notificationBody"] as? Dictionary<AnyHashable, Any>{
                    
                    if let title = body["text_title"] as? String{
                        bestAttemptContent.title = title
                    }
                    if let subTitle = body["text_body"] as? String{
                        bestAttemptContent.body = subTitle
                    }
                    
                }
            }
//            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
            
            let urlString = download.getURLpayload(bestAttemptContent: bestAttemptContent, contentHandler: contentHandler)
            
            download.fileDonwload( urlString: urlString, contentHandler: contentHandler, bestAttemptContent: bestAttemptContent)
            
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        download.downloadTask?.cancel()
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
