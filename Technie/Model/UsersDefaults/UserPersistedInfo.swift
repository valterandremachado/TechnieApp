//
//  UserPersistedInfo.swift
//  Technie
//
//  Created by Valter A. Machado on 2/25/21.
//

import Foundation

struct UserPersistedInfo: Codable {
    let name: String
    let email: String
    let location: String
    let accountType: String?
    let locationInLongLat: LocationInLongAndLat?
    let profileImage: String?
    
    init(name: String,
         email: String,
         location: String,
         accountType: String?,
         locationInLongLat: LocationInLongAndLat?,
         profileImage: String?) {
        
        self.name = name
        self.email = email
        self.location = location
        self.accountType = accountType
        self.locationInLongLat = locationInLongLat
        self.profileImage = profileImage
    }
}

struct LocationInLongAndLat: Codable {
    let lat: String
    let long: String
}
