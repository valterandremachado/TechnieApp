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
    let location: UserPersistedLocation
    let accountType: String?
    let profileImage: String
    let hourlyRate: String?
    let userType: String
    
    init(uid: String,
         name: String,
         email: String,
         location: UserPersistedLocation,
         accountType: String?,
         profileImage: String,
         hourlyRate: String?,
         userType: String) {
        
        self.uid = uid
        self.name = name
        self.email = email
        self.location = location
        self.accountType = accountType
        self.profileImage = profileImage
        self.hourlyRate = hourlyRate
        self.userType = userType
    }
}

struct UserPersistedLocation: Codable {
    let address: String
    let lat: Double
    let long: Double
}
