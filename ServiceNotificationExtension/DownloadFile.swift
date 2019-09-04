//
//  DownloadFile.swift
//  ServiceNotificationExtension
//
//  Created by Cristian Parra on 28-08-19.
//  Copyright © 2019 Cristian Parra. All rights reserved.
//

import Foundation
import UserNotifications

class FileDownloader: NSObject {
    
    var downloadTask: URLSessionDownloadTask?
    
    func fileDonwload( urlString: String, contentHandler: ((UNNotificationContent) -> Void)? ,bestAttemptContent: UNMutableNotificationContent? ) -> Void {
        
        guard let url = URL(string: urlString) else {
            // Cannot create a valid URL, return early.
            contentHandler!(bestAttemptContent!)
            return
        }
        
        self.downloadTask = URLSession.shared.downloadTask(with: url) { (location, response, error) in
            if let location = location {
                let tmpDirectory = NSTemporaryDirectory()
                let tmpFile = "file://".appending(tmpDirectory).appending(url.lastPathComponent)
                
                let tmpUrl = URL(string: tmpFile)!
                try! FileManager.default.moveItem(at: location, to: tmpUrl)
                
                if let attachment = try? UNNotificationAttachment(identifier: "", url: tmpUrl) {
                    bestAttemptContent?.attachments = [attachment]
                }
            }
            
            contentHandler!(bestAttemptContent!)
        }
        
        self.downloadTask?.resume()
    }
    
    func getURLpayload(bestAttemptContent: UNMutableNotificationContent?, contentHandler: ((UNNotificationContent) -> Void)? ) -> String {
        var urlString:String?
        if let url = bestAttemptContent!.userInfo["data"] as? Dictionary<AnyHashable, Any> {
            if let videoURL = url["notificationBody"] as? Dictionary<AnyHashable, Any> {
                
            
                    urlString = videoURL["image_url"] as? String
                
                //                    urlString = videoURL as? String
            }
            else {
                // Nothing to add to the push, return early.
                contentHandler!(bestAttemptContent!)
            }
        }
        return urlString!
    }
}


