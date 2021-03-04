//
//  NotificationEnums.swift
//  Technie
//
//  Created by Valter A. Machado on 3/4/21.
//

import Foundation

enum ClientNotificationType: String {
    case hiringOfferStatus = "Accepted/Rejected Hiring Notification"
    case recommendation = "Recommendation Notification"
    case proposal = "Proposal Notification"
    case review = "Review a Done Job Notification"
}

enum TechnicianNotificationType: String {
    case proposalStatus = "Accepted/Rejected proposals Notification"
    case hiringOffer = "Hiring Offer Notification"
    case closedJob = "Closed Job Notification"
}
