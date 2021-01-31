//
//  ConversationsModels.swift
//  Messenger
//
//  Created by Valter A. Machado on 1/19/21.
//

import Foundation

struct Conversation {
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date: String
    let message: String
    let isRead: Bool
}
