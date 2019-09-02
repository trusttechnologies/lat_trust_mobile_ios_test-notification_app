//
//  DialogNotificationStructs.swift
//  appNotifications
//
//  Created by Jesenia Salazar on 8/28/19.
//  Copyright © 2019 Cristian Parra. All rights reserved.
//

import Foundation

struct GenericNotification: Codable{
    var notificationDialog: DialogNotification?
    var notificationVideo: String?
    var notificationBody: String?
}

struct DialogNotification: Codable {
    var textBody: String
    var imageUrl: String
    var isPersistent: Bool
    var isCancelable: Bool
    var buttons: [Button]
}

struct VideoNotification: Codable {
    var videoUrl: String
    var minPlayTime: String
    var isPersistent: Bool
    var buttons: [Button]
}

struct BodyNotification: Codable {
    var textTitle: String
    var textBody: String
    var imageUrl: String
    var buttons: [Button]
}

struct Button: Codable{
    var type: String
    var text: String
    var color: String
    var action: String
}
