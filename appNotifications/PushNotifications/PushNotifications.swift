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

class PushNotifications: NSObject {
    
    //var genericNotification: GenericNotification = GenericNotification.
    
    var clientId: String?
    var clientSecret: String?
    var serviceName: String?
    var accesGroup: String?
    
    init(clientId:String, clientSecret:String, serviceName:String, accesGroup:String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.serviceName = serviceName
        self.accesGroup = accesGroup
    }
    
    func firebaseConfig(application: UIApplication) {
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        // Set the messaging delegate
        Messaging.messaging().delegate = self
    }
    

    func registerForRemoteNotifications(application: UIApplication){
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
    
    func registerCustomNotificationCategory() {
        //Buttons
        let acceptAction = UNNotificationAction(identifier: "accept", title:  "Aceptar", options: [.foreground])
        let denyAction = UNNotificationAction(identifier: "cancel", title: "Cancelar", options: [.destructive])
        //Notification
        let customCategory =  UNNotificationCategory(
                                identifier: "buttons",
                                actions: [acceptAction,denyAction],
                                intentIdentifiers: [],
                                options: []
                                )
        
        UNUserNotificationCenter.current().setNotificationCategories([customCategory])
    }
    
    func clearBadgeNumber() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}


//MARK: Messaging Delegate
extension PushNotifications: MessagingDelegate{
    
    // MARK:  Monitor token refresh
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        Identify.shared.trustDeviceInfoDelegate = self
//        let serviceName = "defaultServiceName"
//        let accesGroup = "P896AB2AMC.trustID.appLib"
//
//        let clientId = "adcc11078bee4ba2d7880a48c4bed02758a5f5328276b08fa14493306f1e9efb"
//        let clientSecret = "1f647aab37f4a7d7a0da408015437e7a963daca43da06a7789608c319c2930bd"
        
        Identify.shared.set(serviceName: serviceName!, accessGroup: accesGroup!)
        Identify.shared.createClientCredentials(clientID: clientId!, clientSecret: clientSecret!)
//        print("CLIENT CREDENTIALS: \(Identify.shared.getClientCredentials())")
        Identify.shared.enable()
        //Identify.shared.getTrustID()
        let bundle = Bundle.main.bundleIdentifier
        Identify.shared.registerFirebaseToken(firebaseToken: fcmToken, bundleID: bundle!)
        
    }
    
    // MARK: Mapping your APNs token and registration token
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        //print("Received data message: \(remoteMessage.appData)")
    }
}


//MARK: TrustID Handling
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

//MARK: UserNotifications Handling
extension PushNotifications: UNUserNotificationCenterDelegate{
    

    // MARK: FOREGROUND
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        
        let genericNotification = parseNotification(content: userInfo)
        
        switch genericNotification.type {
            case "notificationBody":
                presentBodyNotification(content: genericNotification)
            case "notificationDialog":
                presentDialog(content: genericNotification)
            case "notificationVideo":
                presentVideo(content: genericNotification)
        default:
            print("error: must specify a notification type")
        }
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(notification.request.content.userInfo)
        
        completionHandler([])
    }
    
    // MARK: BACKGROUND
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let genericNotification = parseNotification(content: response.notification.request.content.userInfo)
        
        switch response.actionIdentifier {
        case "accept":
            let url = response.notification.request.content.userInfo["url-scheme"] as? String
            UIApplication.shared.open(URL(string: url!)!, options: [:], completionHandler: nil)
            UIApplication.shared.applicationIconBadgeNumber = 0
        case "cancel":
            UIApplication.shared.applicationIconBadgeNumber = 0
        default:
            print("Other Action")
            switch genericNotification.type {
            case "notificationBody":
                presentBodyNotification(content: genericNotification)
            case "notificationDialog":
                presentDialog(content: genericNotification)
            case "notificationVideo":
                presentVideo(content: genericNotification)
            default:
                print("error: must specify a notification type")
            }
        }
        
        completionHandler()

    }
}

//MARK: DIALOGS

extension PushNotifications{
    func presentDialog(content: GenericNotification!){
        
        let storyboard = UIStoryboard(name: "DialogView", bundle: nil)
        let dialogVC = storyboard.instantiateViewController(withIdentifier: "DialogView") as? DialogViewController
        
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        let window = UIApplication.shared.keyWindow
        
        dialogVC?.modalPresentationStyle = .overCurrentContext
        dialogVC?.setBackground(color: .SOLID)
        dialogVC?.fillDialog(content: content)
        vc.present(dialogVC!, animated: true)
    
        window?.makeKeyAndVisible()
    }
    func presentVideo(content: GenericNotification){
        //To Do
        let storyboard = UIStoryboard(name: "VideoView", bundle: nil)
        let videoVC = storyboard.instantiateViewController(withIdentifier: "VideoView") as? VideoViewController
        
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        let window = UIApplication.shared.keyWindow
        
        videoVC?.modalPresentationStyle = .overCurrentContext
        videoVC?.setBackground(color: .SOLID)
        
        videoVC?.fillVideo(content: content)
        vc.present(videoVC!, animated: true)
        
        window?.makeKeyAndVisible()
    }
    func presentBodyNotification(content: GenericNotification){
        //To Do
        print("aquí deberia ir un body")
    }
}
