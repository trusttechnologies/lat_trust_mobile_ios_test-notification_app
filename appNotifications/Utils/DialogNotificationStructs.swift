//
//  DialogNotificationStructs.swift
//  appNotifications
//
//  Created by Jesenia Salazar on 8/28/19.
//  Copyright © 2019 Cristian Parra. All rights reserved.
//

import Foundation

struct GenericNotification: Codable {
    var type: String!
    var notificationDialog: NotificationDialog?
    var notificationVideo: VideoNotification?
    var notificationBody: BodyNotification?

    enum CodingKeys: String, CodingKey {
        case type
        case notificationDialog
        case notificationVideo
        case notificationBody
    }
}

struct NotificationDialog: Codable {
    var textBody: String
    var imageUrl: String
    var isPersistent: Bool
    var isCancelable: Bool
    var buttons: [Button]?

    enum CodingKeys: String, CodingKey {
        case buttons
        case imageUrl = "image_url"
        case isPersistent = "isPersistent"
        case isCancelable = "isCancelable"
        case textBody = "text_body"
    }
}

struct VideoNotification: Codable {
    var videoUrl: String
    var minPlayTime: Float
    var isPersistent: Bool
    var buttons: [Button]

    enum CodingKeys: String, CodingKey {
        case buttons
        case videoUrl = "video_url"
        case minPlayTime = "min_play_time"
        case isPersistent = "isPersistent"

    }
}

struct BodyNotification: Codable {
    var textTitle: String
    var textBody: String
    var imageUrl: String
    var buttons: [Button]

    enum CodingKeys: String, CodingKey {
        case buttons
        case textTitle = "text_title"
        case textBody = "text_body"
        case imageUrl = "image_url"

    }
}

struct Button: Codable {
    var type: String
    var text: String
    var color: String
    var action: String
}
