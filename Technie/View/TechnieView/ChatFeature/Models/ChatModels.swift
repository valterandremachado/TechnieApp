//
//  ChatModels.swift
//  Messenger
//
//  Created by Valter A. Machado on 1/19/21.
//

import UIKit
import CoreLocation
import MessageKit

struct Message: MessageType {
    public var sender: SenderType
    public var messageId: String
    public var sentDate: Date
    public var sender_email: String?
    public var kind: MessageKind
    public var content: String?
}

//struct Messsage {
//    public var sender_email: String
//    public var name: String
//    public var type: String
//    public var content: String
//}

extension MessageKind {
    var messageKindString: String {
        switch self {
        case .text(_):
            return "text"
        case .attributedText(_):
            return "attributed_text"
        case .photo(_):
            return "photo"
        case .video(_):
            return "video"
        case .location(_):
            return "location"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "audio"
        case .contact(_):
            return "contact"
        case .custom(_):
            return "custom"
        case .linkPreview(_):
            return "linkPreview"
        }
    }
}

struct Sender: SenderType {
    public var photoURL: String
    public var senderId: String
    public var displayName: String
}

struct Media: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}

struct Location: LocationItem {
    var location: CLLocation
    var size: CGSize
}
