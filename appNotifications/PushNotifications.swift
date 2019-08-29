//
//  PushNotifications.swift
//  appNotifications
//
//  Created by Cristian Parra on 27-08-19.
//  Copyright © 2019 Cristian Parra. All rights reserved.
//

import Foundation
import UserNotifications
import Firebase
import FirebaseMessaging
import TrustDeviceInfo


class PushNotifications: NSObject, MessagingDelegate, UNUserNotificationCenterDelegate{
    
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            // 1. Check if permission granted
            guard granted else { return }
            // 2. Attempt registration for remote notifications on the main thread
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        Messaging.messaging().delegate = self
    }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        Identify.shared.trustDeviceInfoDelegate = self
        Identify.shared.set(serviceName: "defaultServiceName", accessGroup: "P896AB2AMC.trust.appNotifications")
        Identify.shared.createClientCredentials(clientID: "982862e9fa91bc66da8fd5731241ab9f3c9c0ca7df8e6fc9eeb47b97c160f39b", clientSecret: "5608eba6cc53cd94abca50ec3f87142006af9fdf5f2d278445f604218467f5d7")
        print("CLIENT CREDENTIALS: \(Identify.shared.getClientCredentials())")
        Identify.shared.enable()
        //Identify.shared.getTrustID()
        let bundle = Bundle.main.bundleIdentifier
        Identify.shared.registerFirebaseToken(firebaseToken: fcmToken, bundleID: bundle!)
        
    }
    
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "accept":
            let url = response.notification.request.content.userInfo["url-scheme"] as? String
            UIApplication.shared.open(URL(string: url!)!, options: [:], completionHandler: nil)
            UIApplication.shared.applicationIconBadgeNumber = 0
            
        case "cancel":
            UIApplication.shared.applicationIconBadgeNumber = 0
        default:
            print("Other Action")
        }
        
        completionHandler()
    }
    
    func registerCustomNotificationCategory() {
        //Buttons
        let acceptAction = UNNotificationAction(identifier: "accept", title:  "Aceptar", options: [.foreground])
        let denyAction = UNNotificationAction(identifier: "cancel", title: "Cancelar", options: [.destructive])
        //Notification
        let customCategory =  UNNotificationCategory(identifier: "buttons",
                                                     actions: [acceptAction,denyAction],
                                                     intentIdentifiers: [],
                                                     options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([customCategory])
    }
    
    func clearBadgeNumber() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}

extension PushNotifications: TrustDeviceInfoDelegate{
    func onClientCredentialsSaved(savedClientCredentials: ClientCredentials) {
        //TODO:
    }
    
    func onTrustIDSaved(savedTrustID: String) {
        //TODO:
    }
    
    func onRegisterFirebaseTokenSuccess(responseData: RegisterFirebaseTokenResponse) {
        print("onRegisterFirebaseTokenSuccess \n\(responseData)\n")
        
    }
    
    func onSendDeviceInfoResponse(status: ResponseStatus) {
        //TODO:
    }
    
    
}

