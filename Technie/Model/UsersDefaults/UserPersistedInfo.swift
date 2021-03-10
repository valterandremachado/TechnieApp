//
//  UserPersistedInfo.swift
//  Technie
//
//  Created by Valter A. Machado on 2/25/21.
//

import Foundation

struct UserPersistedInfo: Codable {
    let uid: String
    let name: String
    let email: String
    let location: String
    let accountType: String?
    let locationInLongLat: LocationInLongAndLat?
    let profileImage: String?
    let hourlyRate: Int?
    
    init(uid: String,
         name: String,
         email: String,
         location: String,
         accountType: String?,
         locationInLongLat: LocationInLongAndLat?,
         profileImage: String?,
         hourlyRate: Int?) {
        
        self.uid = uid
        self.name = name
        self.email = email
        self.location = location
        self.accountType = accountType
        self.locationInLongLat = locationInLongLat
        self.profileImage = profileImage
        self.hourlyRate = hourlyRate
    }
}

struct LocationInLongAndLat: Codable {
    let lat: String
    let long: String
}
